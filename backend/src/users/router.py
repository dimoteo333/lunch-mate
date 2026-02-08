from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload

from src.core.database import get_db
from src.core.security import get_current_user
from src.models.user import User
from src.schemas.user import UserResponse, UserUpdate

router = APIRouter(prefix="/users", tags=["사용자"])


@router.get("/me", response_model=UserResponse)
async def get_me(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """현재 사용자 정보 조회"""
    # Eagerly load company relationship to avoid lazy loading errors (MissingGreenlet)
    result = await db.execute(
        select(User)
        .options(selectinload(User.company))
        .where(User.user_id == current_user.user_id)
    )
    user = result.scalar_one()

    return UserResponse(
        user_id=user.user_id,
        email=user.email,
        nickname=user.nickname,
        company_domain=user.company_domain,
        company_name=user.company.company_name if user.company else None,
        team_name=user.team_name,
        job_title=user.job_title,
        gender=user.gender,
        age_group=user.age_group,
        bio=user.bio,
        interests=user.interests,
        rating_score=user.rating_score,
        total_reviews=user.total_reviews,
        is_email_verified=user.is_email_verified,
        onboarding_completed=user.onboarding_completed,
        created_at=user.created_at,
    )


@router.patch("/me", response_model=UserResponse)
async def update_me(
    data: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """현재 사용자 정보 수정"""
    update_data = data.model_dump(exclude_unset=True)

    for field, value in update_data.items():
        setattr(current_user, field, value)

    await db.flush()

    # Eagerly load company relationship
    result = await db.execute(
        select(User)
        .options(selectinload(User.company))
        .where(User.user_id == current_user.user_id)
    )
    user = result.scalar_one()

    return UserResponse(
        user_id=user.user_id,
        email=user.email,
        nickname=user.nickname,
        company_domain=user.company_domain,
        company_name=user.company.company_name if user.company else None,
        team_name=user.team_name,
        job_title=user.job_title,
        gender=user.gender,
        age_group=user.age_group,
        bio=user.bio,
        interests=user.interests,
        rating_score=user.rating_score,
        total_reviews=user.total_reviews,
        is_email_verified=user.is_email_verified,
        onboarding_completed=user.onboarding_completed,
        created_at=user.created_at,
    )
