from pydantic import BaseModel, EmailStr
from datetime import datetime


class UserCreate(BaseModel):
    email: EmailStr
    nickname: str


class UserUpdate(BaseModel):
    nickname: str | None = None
    team_name: str | None = None
    job_title: str | None = None
    gender: str | None = None
    age_group: str | None = None
    bio: str | None = None
    interests: list[str] | None = None
    company_lat: float | None = None
    company_lon: float | None = None
    home_lat: float | None = None
    home_lon: float | None = None


class UserResponse(BaseModel):
    user_id: str
    email: str
    nickname: str
    company_domain: str
    company_name: str | None = None
    team_name: str | None = None
    job_title: str | None = None
    gender: str | None = None
    age_group: str | None = None
    bio: str | None = None
    interests: list[str] | None = None
    rating_score: float
    total_reviews: int
    is_email_verified: bool
    onboarding_completed: bool
    created_at: datetime

    class Config:
        from_attributes = True


class UserBriefResponse(BaseModel):
    user_id: str
    nickname: str
    rating_score: float

    class Config:
        from_attributes = True
