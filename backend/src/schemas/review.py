from pydantic import BaseModel, Field
from datetime import datetime


class ReviewCreate(BaseModel):
    party_id: str
    reviewee_id: str
    rating: int = Field(..., ge=1, le=5)
    comment: str | None = None


class ReviewResponse(BaseModel):
    review_id: str
    party_id: str
    reviewer_id: str
    reviewee_id: str
    rating: int
    comment: str | None = None
    created_at: datetime

    class Config:
        from_attributes = True


class PendingReviewResponse(BaseModel):
    party_id: str
    party_title: str
    reviewee_id: str
    reviewee_nickname: str
