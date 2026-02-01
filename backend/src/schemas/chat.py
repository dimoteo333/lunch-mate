from pydantic import BaseModel
from datetime import datetime

from src.schemas.user import UserBriefResponse


class ChatRoomResponse(BaseModel):
    room_id: str
    party_id: str
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


class ChatMessageCreate(BaseModel):
    content: str


class ChatMessageResponse(BaseModel):
    message_id: str
    room_id: str
    sender_id: str
    sender: UserBriefResponse
    content: str
    created_at: datetime

    class Config:
        from_attributes = True


class ChatMessageListResponse(BaseModel):
    items: list[ChatMessageResponse]
    has_more: bool
