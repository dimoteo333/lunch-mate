from sqlalchemy import String, Boolean, ForeignKey, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime, timezone
import uuid

from src.core.database import Base


def generate_uuid() -> str:
    return str(uuid.uuid4())


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


class Notification(Base):
    __tablename__ = "notifications"

    notification_id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=generate_uuid
    )
    user_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.user_id"), index=True
    )
    sender_id: Mapped[str | None] = mapped_column(
        String(36), ForeignKey("users.user_id"), index=True
    )
    type: Mapped[str] = mapped_column(String(50))  # e.g., "mention", "party_join"
    content: Mapped[str] = mapped_column(String(500))
    reference_id: Mapped[str | None] = mapped_column(String(36))  # e.g., room_id or party_id
    is_read: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=utc_now, index=True)

    # Relationships
    user: Mapped["User"] = relationship("User", foreign_keys=[user_id])
    sender: Mapped["User"] = relationship("User", foreign_keys=[sender_id])

# Import for type hints
from src.models.user import User  # noqa: E402, F401
