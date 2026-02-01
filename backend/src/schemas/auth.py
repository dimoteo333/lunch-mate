from pydantic import BaseModel, EmailStr


class EmailVerificationRequest(BaseModel):
    email: EmailStr


class VerifyCodeRequest(BaseModel):
    email: EmailStr
    code: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    is_new_user: bool = False


class OnboardingStep1(BaseModel):
    """닉네임, 성별, 연령대"""

    nickname: str
    gender: str | None = None
    age_group: str | None = None


class OnboardingStep2(BaseModel):
    """직장 정보"""

    team_name: str | None = None
    job_title: str | None = None


class OnboardingStep3(BaseModel):
    """위치 정보"""

    company_lat: float | None = None
    company_lon: float | None = None
    home_lat: float | None = None
    home_lon: float | None = None


class OnboardingStep4(BaseModel):
    """자기소개, 관심사"""

    bio: str | None = None
    interests: list[str] | None = None
