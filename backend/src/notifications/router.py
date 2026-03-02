from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from src.core.database import get_db
from src.core.security import get_current_active_user
from src.models.user import User
from src.models.notification import Notification
from src.schemas.notification import NotificationResponse

router = APIRouter(prefix="/notifications", tags=["알림"])


@router.get("", response_model=list[NotificationResponse])
async def get_notifications(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """사용자의 알림 목록 조회"""
    result = await db.execute(
        select(Notification)
        .where(Notification.user_id == current_user.user_id)
        .order_by(Notification.created_at.desc())
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()


@router.patch("/{notification_id}/read", response_model=NotificationResponse)
async def mark_as_read(
    notification_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    """알림 읽음 처리"""
    result = await db.execute(
        select(Notification).where(
            Notification.notification_id == notification_id,
            Notification.user_id == current_user.user_id,
        )
    )
    notif = result.scalar_one_or_none()
    if getattr(notif, "is_read", None) is False:
        notif.is_read = True
        await db.commit()
        await db.refresh(notif)
    return notif
