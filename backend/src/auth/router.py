from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from datetime import timedelta

from src.core.database import get_db
from src.core.security import (
    create_access_token,
    generate_otp,
    get_current_user,
)
from src.core.email_validation import (
    is_personal_email,
    is_whitelisted_domain,
    get_company_info,
)
from src.config import settings
from src.models.user import User, CompanyDomain
from src.schemas.auth import (
    EmailVerificationRequest,
    VerifyCodeRequest,
    TokenResponse,
    OnboardingStep1,
    OnboardingStep2,
    OnboardingStep3,
    OnboardingStep4,
)

router = APIRouter(prefix="/auth", tags=["인증"])

# In-memory OTP storage (use Redis in production)
otp_storage: dict[str, str] = {}


@router.post("/email-verification/send")
async def send_verification_email(
    request: EmailVerificationRequest,
    db: AsyncSession = Depends(get_db),
):
    """이메일 인증 코드 발송"""
    email = request.email.lower()
    domain = email.split("@")[1]

    # 1. 개인 이메일 차단
    if is_personal_email(email):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="개인 이메일(gmail, naver 등)은 사용할 수 없습니다. 회사 이메일을 사용해주세요.",
        )

    # 2. 기존 도메인 확인
    result = await db.execute(
        select(CompanyDomain).where(CompanyDomain.domain == domain)
    )
    company = result.scalar_one_or_none()

    if not company:
        # 3. 화이트리스트 확인
        company_info = get_company_info(domain)
        
        if company_info:
            # 화이트리스트에 있음 -> 자동 승인
            company_name, industry = company_info
            company = CompanyDomain(
                domain=domain,
                company_name=company_name,
                industry=industry,
                whitelisted=True,
            )
            db.add(company)
            await db.flush()
        else:
            # 화이트리스트에 없음 -> 승인 대기 상태로 생성
            company = CompanyDomain(
                domain=domain,
                company_name=domain.split(".")[0].title(),
                whitelisted=False,  # 관리자 승인 필요
            )
            db.add(company)
            await db.flush()
            
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"'{domain}' 도메인은 아직 등록되지 않은 기업입니다. 관리자 승인 후 사용 가능합니다.",
            )

    # 4. 화이트리스트 여부 확인
    if not company.whitelisted:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"'{domain}' 도메인은 현재 승인 대기 중입니다. 관리자 승인 후 사용 가능합니다.",
        )

    # Generate OTP
    otp = generate_otp(settings.OTP_LENGTH)
    otp_storage[email] = otp

    # In development, just return the OTP (would send email in production)
    if settings.DEBUG:
        return {
            "message": "인증 코드가 발송되었습니다",
            "company_name": company.company_name,
            "debug_code": otp,  # Remove in production
        }

    # TODO: Send actual email
    return {
        "message": "인증 코드가 발송되었습니다",
        "company_name": company.company_name,
    }


@router.post("/email-verification/verify", response_model=TokenResponse)
async def verify_email(
    request: VerifyCodeRequest,
    db: AsyncSession = Depends(get_db),
):
    """이메일 인증 코드 확인"""
    email = request.email.lower()

    # Verify OTP
    stored_otp = otp_storage.get(email)
    if not stored_otp or stored_otp != request.code:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="잘못된 인증 코드입니다",
        )

    # Clear OTP
    del otp_storage[email]

    # Check if user exists
    result = await db.execute(select(User).where(User.email == email))
    user = result.scalar_one_or_none()
    is_new_user = False

    if not user:
        # Create new user
        domain = email.split("@")[1]
        user = User(
            email=email,
            company_domain=domain,
            nickname=email.split("@")[0],
            is_email_verified=True,
        )
        db.add(user)
        await db.flush()
        is_new_user = True
    else:
        user.is_email_verified = True

    # Create access token
    access_token = create_access_token(
        data={"sub": user.user_id},
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES),
    )

    return TokenResponse(
        access_token=access_token,
        is_new_user=is_new_user,
    )


@router.post("/onboarding/step1")
async def onboarding_step1(
    data: OnboardingStep1,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """온보딩 1단계: 닉네임, 성별, 연령대"""
    current_user.nickname = data.nickname
    current_user.gender = data.gender
    current_user.age_group = data.age_group
    return {"message": "저장되었습니다"}


@router.post("/onboarding/step2")
async def onboarding_step2(
    data: OnboardingStep2,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """온보딩 2단계: 직장 정보"""
    current_user.team_name = data.team_name
    current_user.job_title = data.job_title
    return {"message": "저장되었습니다"}


@router.post("/onboarding/step3")
async def onboarding_step3(
    data: OnboardingStep3,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """온보딩 3단계: 위치 정보"""
    current_user.company_lat = data.company_lat
    current_user.company_lon = data.company_lon
    current_user.home_lat = data.home_lat
    current_user.home_lon = data.home_lon
    return {"message": "저장되었습니다"}


@router.post("/onboarding/step4")
async def onboarding_step4(
    data: OnboardingStep4,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """온보딩 4단계: 자기소개, 관심사"""
    current_user.bio = data.bio
    current_user.interests = data.interests
    return {"message": "저장되었습니다"}


@router.post("/onboarding/complete")
async def complete_onboarding(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """온보딩 완료"""
    current_user.onboarding_completed = True
    return {"message": "온보딩이 완료되었습니다"}
