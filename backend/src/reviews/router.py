from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_
from sqlalchemy.orm import selectinload

from src.core.database import get_db
from src.core.security import get_current_active_user
from src.models.user import User
from src.models.party import Party, PartyParticipant, PartyStatus
from src.models.review import Review
from src.schemas.review import ReviewCreate, ReviewResponse, PendingReviewResponse

router = APIRouter(prefix="/reviews", tags=["평가"])


@router.post("", response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
async def create_review(
    data: ReviewCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """평가 작성"""
    # Check if party exists and is completed
    result = await db.execute(
        select(Party)
        .options(selectinload(Party.participants))
        .where(Party.party_id == data.party_id)
    )
    party = result.scalar_one_or_none()

    if not party:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="파티를 찾을 수 없습니다",
        )

    if party.status != PartyStatus.COMPLETED:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="완료된 파티만 평가할 수 있습니다",
        )

    # Check if reviewer was participant
    reviewer_participant = next(
        (
            p
            for p in party.participants
            if p.user_id == current_user.user_id and p.status == "joined"
        ),
        None,
    )
    if not reviewer_participant:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="파티 참가자만 평가할 수 있습니다",
        )

    # Check if reviewee was participant
    reviewee_participant = next(
        (
            p
            for p in party.participants
            if p.user_id == data.reviewee_id and p.status == "joined"
        ),
        None,
    )
    if not reviewee_participant:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="평가 대상이 파티 참가자가 아닙니다",
        )

    # Check if already reviewed
    result = await db.execute(
        select(Review).where(
            and_(
                Review.party_id == data.party_id,
                Review.reviewer_id == current_user.user_id,
                Review.reviewee_id == data.reviewee_id,
            )
        )
    )
    if result.scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="이미 평가를 작성했습니다",
        )

    # Create review
    review = Review(
        party_id=data.party_id,
        reviewer_id=current_user.user_id,
        reviewee_id=data.reviewee_id,
        rating=data.rating,
        comment=data.comment,
    )
    db.add(review)

    # Update reviewee's rating
    result = await db.execute(select(User).where(User.user_id == data.reviewee_id))
    reviewee = result.scalar_one()

    # Simple average calculation
    new_total = reviewee.total_reviews + 1
    new_score = (
        (reviewee.rating_score * reviewee.total_reviews) + (data.rating * 20)
    ) / new_total
    reviewee.rating_score = min(100, max(0, new_score))
    reviewee.total_reviews = new_total

    await db.flush()

    return ReviewResponse(
        review_id=review.review_id,
        party_id=review.party_id,
        reviewer_id=review.reviewer_id,
        reviewee_id=review.reviewee_id,
        rating=review.rating,
        comment=review.comment,
        created_at=review.created_at,
    )


@router.get("/pending", response_model=list[PendingReviewResponse])
async def get_pending_reviews(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """작성해야 할 평가 목록"""
    # Get completed parties where user participated
    result = await db.execute(
        select(Party)
        .options(
            selectinload(Party.participants).selectinload(PartyParticipant.user)
        )
        .join(PartyParticipant)
        .where(
            and_(
                PartyParticipant.user_id == current_user.user_id,
                PartyParticipant.status == "joined",
                Party.status == PartyStatus.COMPLETED,
            )
        )
    )
    parties = result.scalars().all()

    pending = []
    for party in parties:
        # Get existing reviews by current user for this party
        result = await db.execute(
            select(Review.reviewee_id).where(
                and_(
                    Review.party_id == party.party_id,
                    Review.reviewer_id == current_user.user_id,
                )
            )
        )
        reviewed_ids = set(row[0] for row in result.all())

        # Find unreviewed participants
        for participant in party.participants:
            if (
                participant.user_id != current_user.user_id
                and participant.status == "joined"
                and participant.user_id not in reviewed_ids
            ):
                pending.append(
                    PendingReviewResponse(
                        party_id=party.party_id,
                        party_title=party.title,
                        reviewee_id=participant.user_id,
                        reviewee_nickname=participant.user.nickname,
                    )
                )

    return pending
