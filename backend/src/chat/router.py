from fastapi import APIRouter, Depends, HTTPException, status, Query, WebSocket, WebSocketDisconnect
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from typing import Dict, List
import json

from src.core.database import get_db, async_session_maker
from src.core.security import get_current_active_user, verify_token
from src.models.user import User
from src.models.party import Party, PartyParticipant
from src.models.chat import ChatRoom, ChatMessage
from src.schemas.chat import ChatRoomResponse, ChatMessageResponse, ChatMessageListResponse
from src.schemas.user import UserBriefResponse

router = APIRouter(prefix="/chat", tags=["채팅"])

# WebSocket connection manager
class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, room_id: str):
        await websocket.accept()
        if room_id not in self.active_connections:
            self.active_connections[room_id] = []
        self.active_connections[room_id].append(websocket)

    def disconnect(self, websocket: WebSocket, room_id: str):
        if room_id in self.active_connections:
            self.active_connections[room_id].remove(websocket)
            if not self.active_connections[room_id]:
                del self.active_connections[room_id]

    async def broadcast(self, room_id: str, message: dict):
        if room_id in self.active_connections:
            for connection in self.active_connections[room_id]:
                await connection.send_json(message)


manager = ConnectionManager()


@router.get("/rooms/party/{party_id}", response_model=ChatRoomResponse)
async def get_room_by_party(
    party_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """파티의 채팅방 조회"""
    result = await db.execute(
        select(ChatRoom).where(ChatRoom.party_id == party_id)
    )
    room = result.scalar_one_or_none()

    if not room:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="채팅방을 찾을 수 없습니다",
        )

    # Check if user is participant
    result = await db.execute(
        select(PartyParticipant).where(
            PartyParticipant.party_id == party_id,
            PartyParticipant.user_id == current_user.user_id,
            PartyParticipant.status == "joined",
        )
    )
    participant = result.scalar_one_or_none()

    if not participant:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="파티 참가자만 채팅방에 접근할 수 있습니다",
        )

    return room


@router.get("/rooms/{room_id}/messages", response_model=ChatMessageListResponse)
async def get_messages(
    room_id: str,
    before: str | None = None,
    limit: int = Query(50, ge=1, le=100),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """채팅 메시지 목록 조회"""
    # Check room access
    result = await db.execute(
        select(ChatRoom).where(ChatRoom.room_id == room_id)
    )
    room = result.scalar_one_or_none()

    if not room:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="채팅방을 찾을 수 없습니다",
        )

    result = await db.execute(
        select(PartyParticipant).where(
            PartyParticipant.party_id == room.party_id,
            PartyParticipant.user_id == current_user.user_id,
            PartyParticipant.status == "joined",
        )
    )
    if not result.scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="채팅방 접근 권한이 없습니다",
        )

    # Query messages
    query = (
        select(ChatMessage)
        .options(selectinload(ChatMessage.sender))
        .where(ChatMessage.room_id == room_id)
        .order_by(ChatMessage.created_at.desc())
        .limit(limit + 1)
    )

    if before:
        result = await db.execute(
            select(ChatMessage).where(ChatMessage.message_id == before)
        )
        before_msg = result.scalar_one_or_none()
        if before_msg:
            query = query.where(ChatMessage.created_at < before_msg.created_at)

    result = await db.execute(query)
    messages = list(result.scalars().all())

    has_more = len(messages) > limit
    if has_more:
        messages = messages[:limit]

    return ChatMessageListResponse(
        items=[
            ChatMessageResponse(
                message_id=m.message_id,
                room_id=m.room_id,
                sender_id=m.sender_id,
                sender=UserBriefResponse(
                    user_id=m.sender.user_id,
                    nickname=m.sender.nickname,
                    rating_score=m.sender.rating_score,
                ),
                content=m.content,
                created_at=m.created_at,
            )
            for m in reversed(messages)
        ],
        has_more=has_more,
    )


@router.websocket("/ws/{room_id}")
async def websocket_endpoint(websocket: WebSocket, room_id: str):
    """WebSocket 채팅"""
    # Get token from query params
    token = websocket.query_params.get("token")
    if not token:
        await websocket.close(code=4001)
        return

    # Verify token
    payload = verify_token(token)
    if not payload:
        await websocket.close(code=4001)
        return

    user_id = payload.get("sub")

    async with async_session_maker() as db:
        # Check room and access
        result = await db.execute(
            select(ChatRoom).where(ChatRoom.room_id == room_id)
        )
        room = result.scalar_one_or_none()

        if not room:
            await websocket.close(code=4004)
            return

        result = await db.execute(
            select(PartyParticipant).where(
                PartyParticipant.party_id == room.party_id,
                PartyParticipant.user_id == user_id,
                PartyParticipant.status == "joined",
            )
        )
        if not result.scalar_one_or_none():
            await websocket.close(code=4003)
            return

        # Get user info
        result = await db.execute(select(User).where(User.user_id == user_id))
        user = result.scalar_one()

    await manager.connect(websocket, room_id)

    try:
        while True:
            data = await websocket.receive_text()
            message_data = json.loads(data)

            if message_data.get("type") == "message":
                content = message_data.get("content", "").strip()
                if not content:
                    continue

                async with async_session_maker() as db:
                    # Save message
                    message = ChatMessage(
                        room_id=room_id,
                        sender_id=user_id,
                        content=content,
                    )
                    db.add(message)
                    await db.commit()
                    await db.refresh(message)

                    # Broadcast to room
                    await manager.broadcast(
                        room_id,
                        {
                            "type": "message",
                            "message_id": message.message_id,
                            "sender_id": user_id,
                            "sender_nickname": user.nickname,
                            "content": content,
                            "created_at": message.created_at.isoformat(),
                        },
                    )

    except WebSocketDisconnect:
        manager.disconnect(websocket, room_id)
