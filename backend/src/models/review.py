from sqlalchemy import String, Integer, ForeignKey, DateTime, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime, timezone
import uuid

from src.core.database import Base


def generate_uuid() -> str:
    return str(uuid.uuid4())


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


class Review(Base):
    __tablename__ = "reviews"

    review_id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=generate_uuid
    )
    party_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("parties.party_id"), index=True
    )
    reviewer_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.user_id"), index=True
    )
    reviewee_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.user_id"), index=True
    )
    rating: Mapped[int] = mapped_column(Integer)  # 1-5
    comment: Mapped[str | None] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=utc_now)

    # Relationships
    reviewer: Mapped["User"] = relationship("User", foreign_keys=[reviewer_id])
    reviewee: Mapped["User"] = relationship("User", foreign_keys=[reviewee_id])


# Import for type hints
from src.models.user import User  # noqa: E402, F401
