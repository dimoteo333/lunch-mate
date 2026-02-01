from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from src.core.database import get_db
from src.core.security import get_current_user
from src.models.user import User
from src.schemas.user import UserResponse, UserUpdate

router = APIRouter(prefix="/users", tags=["사용자"])


@router.get("/me", response_model=UserResponse)
async def get_me(
    current_user: User = Depends(get_current_user),
):
    """현재 사용자 정보 조회"""
    return UserResponse(
        user_id=current_user.user_id,
        email=current_user.email,
        nickname=current_user.nickname,
        company_domain=current_user.company_domain,
        company_name=current_user.company.company_name if current_user.company else None,
        team_name=current_user.team_name,
        job_title=current_user.job_title,
        gender=current_user.gender,
        age_group=current_user.age_group,
        bio=current_user.bio,
        interests=current_user.interests,
        rating_score=current_user.rating_score,
        total_reviews=current_user.total_reviews,
        is_email_verified=current_user.is_email_verified,
        onboarding_completed=current_user.onboarding_completed,
        created_at=current_user.created_at,
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

    return UserResponse(
        user_id=current_user.user_id,
        email=current_user.email,
        nickname=current_user.nickname,
        company_domain=current_user.company_domain,
        company_name=current_user.company.company_name if current_user.company else None,
        team_name=current_user.team_name,
        job_title=current_user.job_title,
        gender=current_user.gender,
        age_group=current_user.age_group,
        bio=current_user.bio,
        interests=current_user.interests,
        rating_score=current_user.rating_score,
        total_reviews=current_user.total_reviews,
        is_email_verified=current_user.is_email_verified,
        onboarding_completed=current_user.onboarding_completed,
        created_at=current_user.created_at,
    )
