from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from sqlalchemy.orm import selectinload
from math import ceil

from src.core.database import get_db
from src.core.security import get_current_active_user
from src.models.user import User
from src.models.party import Party, PartyParticipant, PartyStatus, LocationType
from src.models.chat import ChatRoom
from src.schemas.party import (
    PartyCreate,
    PartyResponse,
    PartyListResponse,
    ParticipantResponse,
)
from src.schemas.user import UserBriefResponse

router = APIRouter(prefix="/parties", tags=["파티"])


def party_to_response(party: Party) -> PartyResponse:
    return PartyResponse(
        party_id=party.party_id,
        creator_id=party.creator_id,
        creator=UserBriefResponse(
            user_id=party.creator.user_id,
            nickname=party.creator.nickname,
            rating_score=party.creator.rating_score,
        ),
        title=party.title,
        description=party.description,
        location_type=party.location_type.value,
        location_lat=party.location_lat,
        location_lon=party.location_lon,
        location_name=party.location_name,
        start_time=party.start_time,
        duration_minutes=party.duration_minutes,
        max_participants=party.max_participants,
        min_participants=party.min_participants,
        current_participants=party.current_participants,
        status=party.status.value,
        participants=[
            ParticipantResponse(
                participant_id=p.participant_id,
                user_id=p.user_id,
                user=UserBriefResponse(
                    user_id=p.user.user_id,
                    nickname=p.user.nickname,
                    rating_score=p.user.rating_score,
                ),
                status=p.status,
                joined_at=p.joined_at,
            )
            for p in party.participants
            if p.status == "joined"
        ],
        created_at=party.created_at,
    )


@router.get("", response_model=PartyListResponse)
async def list_parties(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    status_filter: str | None = Query(None, alias="status"),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """파티 목록 조회"""
    query = (
        select(Party)
        .options(
            selectinload(Party.creator),
            selectinload(Party.participants).selectinload(PartyParticipant.user),
        )
        .order_by(Party.start_time.asc())
    )

    if status_filter:
        query = query.where(Party.status == PartyStatus(status_filter))
    else:
        query = query.where(Party.status == PartyStatus.RECRUITING)

    # Count total
    count_query = select(func.count(Party.party_id))
    if status_filter:
        count_query = count_query.where(Party.status == PartyStatus(status_filter))
    else:
        count_query = count_query.where(Party.status == PartyStatus.RECRUITING)

    total_result = await db.execute(count_query)
    total = total_result.scalar() or 0

    # Paginate
    query = query.offset((page - 1) * size).limit(size)
    result = await db.execute(query)
    parties = result.scalars().all()

    return PartyListResponse(
        items=[party_to_response(p) for p in parties],
        total=total,
        page=page,
        size=size,
        pages=ceil(total / size) if total > 0 else 1,
    )


@router.post("", response_model=PartyResponse, status_code=status.HTTP_201_CREATED)
async def create_party(
    data: PartyCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """파티 생성"""
    party = Party(
        creator_id=current_user.user_id,
        title=data.title,
        description=data.description,
        location_type=LocationType(data.location_type),
        location_lat=data.location_lat or current_user.company_lat,
        location_lon=data.location_lon or current_user.company_lon,
        location_name=data.location_name,
        start_time=data.start_time,
        duration_minutes=data.duration_minutes,
        max_participants=data.max_participants,
        min_participants=data.min_participants,
        current_participants=1,
    )
    db.add(party)
    await db.flush()

    # Add creator as participant
    participant = PartyParticipant(
        party_id=party.party_id,
        user_id=current_user.user_id,
    )
    db.add(participant)

    # Create chat room
    chat_room = ChatRoom(party_id=party.party_id)
    db.add(chat_room)

    await db.flush()

    # Reload with relationships
    result = await db.execute(
        select(Party)
        .options(
            selectinload(Party.creator),
            selectinload(Party.participants).selectinload(PartyParticipant.user),
        )
        .where(Party.party_id == party.party_id)
    )
    party = result.scalar_one()

    return party_to_response(party)


@router.get("/{party_id}", response_model=PartyResponse)
async def get_party(
    party_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """파티 상세 조회"""
    result = await db.execute(
        select(Party)
        .options(
            selectinload(Party.creator),
            selectinload(Party.participants).selectinload(PartyParticipant.user),
        )
        .where(Party.party_id == party_id)
    )
    party = result.scalar_one_or_none()

    if not party:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="파티를 찾을 수 없습니다",
        )

    return party_to_response(party)


@router.post("/{party_id}/join", response_model=PartyResponse)
async def join_party(
    party_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """파티 참가"""
    result = await db.execute(
        select(Party)
        .options(
            selectinload(Party.creator),
            selectinload(Party.participants).selectinload(PartyParticipant.user),
        )
        .where(Party.party_id == party_id)
    )
    party = result.scalar_one_or_none()

    if not party:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="파티를 찾을 수 없습니다",
        )

    if party.status != PartyStatus.RECRUITING:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="모집이 마감된 파티입니다",
        )

    if party.current_participants >= party.max_participants:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="정원이 가득 찼습니다",
        )

    # Check if already joined
    existing = next(
        (p for p in party.participants if p.user_id == current_user.user_id),
        None,
    )
    if existing and existing.status == "joined":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="이미 참가한 파티입니다",
        )

    if existing:
        existing.status = "joined"
    else:
        participant = PartyParticipant(
            party_id=party.party_id,
            user_id=current_user.user_id,
        )
        db.add(participant)

    party.current_participants += 1

    # Auto-confirm if min participants reached
    if party.current_participants >= party.min_participants:
        party.status = PartyStatus.CONFIRMED

    await db.flush()

    # Reload
    result = await db.execute(
        select(Party)
        .options(
            selectinload(Party.creator),
            selectinload(Party.participants).selectinload(PartyParticipant.user),
        )
        .where(Party.party_id == party_id)
    )
    party = result.scalar_one()

    return party_to_response(party)


@router.delete("/{party_id}/leave", response_model=PartyResponse)
async def leave_party(
    party_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """파티 나가기"""
    result = await db.execute(
        select(Party)
        .options(
            selectinload(Party.creator),
            selectinload(Party.participants).selectinload(PartyParticipant.user),
        )
        .where(Party.party_id == party_id)
    )
    party = result.scalar_one_or_none()

    if not party:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="파티를 찾을 수 없습니다",
        )

    if party.creator_id == current_user.user_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="파티 생성자는 나갈 수 없습니다",
        )

    participant = next(
        (
            p
            for p in party.participants
            if p.user_id == current_user.user_id and p.status == "joined"
        ),
        None,
    )

    if not participant:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="참가하지 않은 파티입니다",
        )

    participant.status = "left"
    party.current_participants -= 1

    # Revert to recruiting if below min
    if party.status == PartyStatus.CONFIRMED and party.current_participants < party.min_participants:
        party.status = PartyStatus.RECRUITING

    await db.flush()

    # Reload
    result = await db.execute(
        select(Party)
        .options(
            selectinload(Party.creator),
            selectinload(Party.participants).selectinload(PartyParticipant.user),
        )
        .where(Party.party_id == party_id)
    )
    party = result.scalar_one()

    return party_to_response(party)
