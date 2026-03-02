from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional

from src.schemas.user import UserBriefResponse


class NotificationResponse(BaseModel):
    notification_id: str
    user_id: str
    sender_id: Optional[str] = None
    sender: Optional[UserBriefResponse] = None
    type: str
    content: str
    reference_id: Optional[str] = None
    is_read: bool
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
