from sqlalchemy import String, Boolean, Float, JSON, ForeignKey, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from datetime import datetime, timezone
import uuid

from src.core.database import Base


def generate_uuid() -> str:
    return str(uuid.uuid4())


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


class CompanyDomain(Base):
    __tablename__ = "company_domains"

    domain_id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=generate_uuid
    )
    domain: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    company_name: Mapped[str] = mapped_column(String(255))
    industry: Mapped[str | None] = mapped_column(String(100))
    hq_latitude: Mapped[float | None] = mapped_column(Float)
    hq_longitude: Mapped[float | None] = mapped_column(Float)
    offices: Mapped[dict | None] = mapped_column(JSON)
    whitelisted: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=utc_now)

    users: Mapped[list["User"]] = relationship("User", back_populates="company")


class User(Base):
    __tablename__ = "users"

    user_id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=generate_uuid
    )
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    company_domain: Mapped[str] = mapped_column(
        String(255), ForeignKey("company_domains.domain"), index=True
    )
    nickname: Mapped[str] = mapped_column(String(50))
    team_name: Mapped[str | None] = mapped_column(String(100))
    job_title: Mapped[str | None] = mapped_column(String(100))
    gender: Mapped[str | None] = mapped_column(String(10))
    age_group: Mapped[str | None] = mapped_column(String(10))
    bio: Mapped[str | None] = mapped_column(String(500))
    interests: Mapped[list | None] = mapped_column(JSON)

    # Location
    company_lat: Mapped[float | None] = mapped_column(Float)
    company_lon: Mapped[float | None] = mapped_column(Float)
    home_lat: Mapped[float | None] = mapped_column(Float)
    home_lon: Mapped[float | None] = mapped_column(Float)

    # Rating
    rating_score: Mapped[float] = mapped_column(Float, default=50.0)
    total_reviews: Mapped[int] = mapped_column(default=0)

    # Status
    is_email_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    onboarding_completed: Mapped[bool] = mapped_column(Boolean, default=False)

    created_at: Mapped[datetime] = mapped_column(DateTime, default=utc_now)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, default=utc_now, onupdate=utc_now
    )

    # Relationships
    company: Mapped["CompanyDomain"] = relationship(
        "CompanyDomain", back_populates="users"
    )
    created_parties: Mapped[list["Party"]] = relationship(
        "Party", back_populates="creator", foreign_keys="Party.creator_id"
    )
    participations: Mapped[list["PartyParticipant"]] = relationship(
        "PartyParticipant", back_populates="user"
    )


# Import Party and PartyParticipant for relationship type hints
from src.models.party import Party, PartyParticipant  # noqa: E402, F401
