from sqlalchemy import String, Integer, Float, ForeignKey, DateTime, Enum
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime, timezone
import uuid
import enum

from src.core.database import Base


def generate_uuid() -> str:
    return str(uuid.uuid4())


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


class PartyStatus(str, enum.Enum):
    RECRUITING = "recruiting"
    CONFIRMED = "confirmed"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class LocationType(str, enum.Enum):
    COMPANY_NEARBY = "company_nearby"
    MIDPOINT = "midpoint"
    SPECIFIC = "specific"


class Party(Base):
    __tablename__ = "parties"

    party_id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=generate_uuid
    )
    creator_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.user_id"), index=True
    )
    title: Mapped[str] = mapped_column(String(100))
    description: Mapped[str | None] = mapped_column(String(500))

    # Location
    location_type: Mapped[LocationType] = mapped_column(
        Enum(LocationType), default=LocationType.COMPANY_NEARBY
    )
    location_lat: Mapped[float | None] = mapped_column(Float)
    location_lon: Mapped[float | None] = mapped_column(Float)
    location_name: Mapped[str | None] = mapped_column(String(200))

    # Time
    start_time: Mapped[datetime] = mapped_column(DateTime)
    duration_minutes: Mapped[int] = mapped_column(Integer, default=60)

    # Participants
    max_participants: Mapped[int] = mapped_column(Integer, default=4)
    min_participants: Mapped[int] = mapped_column(Integer, default=2)
    current_participants: Mapped[int] = mapped_column(Integer, default=1)

    # Status
    status: Mapped[PartyStatus] = mapped_column(
        Enum(PartyStatus), default=PartyStatus.RECRUITING
    )

    created_at: Mapped[datetime] = mapped_column(DateTime, default=utc_now)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, default=utc_now, onupdate=utc_now
    )

    # Relationships
    creator: Mapped["User"] = relationship(
        "User", back_populates="created_parties", foreign_keys=[creator_id]
    )
    participants: Mapped[list["PartyParticipant"]] = relationship(
        "PartyParticipant", back_populates="party", cascade="all, delete-orphan"
    )
    chat_room: Mapped["ChatRoom"] = relationship(
        "ChatRoom", back_populates="party", uselist=False
    )


class PartyParticipant(Base):
    __tablename__ = "party_participants"

    participant_id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=generate_uuid
    )
    party_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("parties.party_id"), index=True
    )
    user_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.user_id"), index=True
    )
    status: Mapped[str] = mapped_column(String(20), default="joined")
    joined_at: Mapped[datetime] = mapped_column(DateTime, default=utc_now)

    # Relationships
    party: Mapped["Party"] = relationship("Party", back_populates="participants")
    user: Mapped["User"] = relationship("User", back_populates="participations")


# Import for type hints
from src.models.user import User  # noqa: E402, F401
from src.models.chat import ChatRoom  # noqa: E402, F401
