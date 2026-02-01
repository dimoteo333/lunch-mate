from sqlalchemy import String, Boolean, ForeignKey, DateTime, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime, timezone
import uuid

from src.core.database import Base


def generate_uuid() -> str:
    return str(uuid.uuid4())


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


class ChatRoom(Base):
    __tablename__ = "chat_rooms"

    room_id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=generate_uuid
    )
    party_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("parties.party_id"), unique=True, index=True
    )
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=utc_now)

    # Relationships
    party: Mapped["Party"] = relationship("Party", back_populates="chat_room")
    messages: Mapped[list["ChatMessage"]] = relationship(
        "ChatMessage", back_populates="room", cascade="all, delete-orphan"
    )


class ChatMessage(Base):
    __tablename__ = "chat_messages"

    message_id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=generate_uuid
    )
    room_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("chat_rooms.room_id"), index=True
    )
    sender_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.user_id"), index=True
    )
    content: Mapped[str] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=utc_now, index=True)

    # Relationships
    room: Mapped["ChatRoom"] = relationship("ChatRoom", back_populates="messages")
    sender: Mapped["User"] = relationship("User")


# Import for type hints
from src.models.party import Party  # noqa: E402, F401
from src.models.user import User  # noqa: E402, F401
