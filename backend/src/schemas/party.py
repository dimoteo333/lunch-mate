from pydantic import BaseModel
from datetime import datetime
from typing import Optional

from src.schemas.user import UserBriefResponse


class PartyCreate(BaseModel):
    title: str
    description: str | None = None
    location_type: str = "company_nearby"
    location_lat: float | None = None
    location_lon: float | None = None
    location_name: str | None = None
    start_time: datetime
    duration_minutes: int = 60
    max_participants: int = 4
    min_participants: int = 2


class PartyUpdate(BaseModel):
    title: str | None = None
    description: str | None = None
    location_name: str | None = None
    start_time: datetime | None = None


class ParticipantResponse(BaseModel):
    participant_id: str
    user_id: str
    user: UserBriefResponse
    status: str
    joined_at: datetime

    class Config:
        from_attributes = True


class PartyResponse(BaseModel):
    party_id: str
    creator_id: str
    creator: UserBriefResponse
    title: str
    description: str | None = None
    location_type: str
    location_lat: float | None = None
    location_lon: float | None = None
    location_name: str | None = None
    start_time: datetime
    duration_minutes: int
    max_participants: int
    min_participants: int
    current_participants: int
    status: str
    participants: list[ParticipantResponse]
    created_at: datetime
    distance_km: float | None = None

    class Config:
        from_attributes = True


class PartyListResponse(BaseModel):
    items: list[PartyResponse]
    total: int
    page: int
    size: int
    pages: int
