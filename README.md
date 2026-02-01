# Lunch-Mate: Claude Code 개발 프롬프트 가이드

이 문서는 "직장인 전용 점심 약속 매칭 플랫폼 lunch-mate"의 기획 레포트를 Claude Code에서 구현하기 위한 상세 프롬프트입니다. 각 섹션별로 복사-붙여넣기하여 사용할 수 있습니다.

---

## 1. 인증 시스템 프롬프트

### 1.1 SMTP 이메일 인증 백엔드 구현

당신은 Python FastAPI 전문가입니다. 다음 요구사항에 따라 SMTP 이메일 인증 시스템을 구현해주세요.

[요구사항]
- 이메일 도메인 기반 직장인 인증
- Redis를 활용한 인증 코드 저장 (TTL: 300초)
- 중복 가입 방지 (30초 재전송 대기)
- Gmail 또는 AWS SES를 통한 발송
- 에러 처리 및 재시도 로직 (Celery)

[구현 범위]
1. `/api/v1/auth/email-verification/send` - POST
   - 요청: {"email": "user@company.co.kr"}
   - 응답: {"message": "인증 이메일 발송 완료", "expires_in": 300}

2. `/api/v1/auth/email-verification/verify` - POST
   - 요청: {"email": "user@company.co.kr", "code": "a1b2c3"}
   - 응답: {"verified": true, "domain": "company.co.kr"}

3. Redis 키 구조
   - Key: `verify:{email}`
   - Value: JSON {"code": "a1b2c3", "attempts": 3}
   - TTL: 300초

4. 보안 고려사항
   - 3회 이상 실패 시 차단
   - 이메일 정규식 검증
   - Rate limiting (1분당 1회만 발송)

[기술 스택]
- FastAPI + Python 3.10+
- Redis (redis-py)
- smtplib (Gmail 기본) 또는 boto3 (AWS SES)
- Celery (선택, 비동기 발송)

[코드 제공]
완전한 FastAPI 라우터 코드와 유틸 함수, 테스트 케이스를 작성해주세요.

### 1.2 회사 도메인 화이트리스트 관리

FastAPI 백엔드에서 회사 도메인 화이트리스트를 관리하는 시스템을 구현해주세요.

[요구사항]
- PostgreSQL에 회사 도메인 저장
- 회사 이름, 본사 위치(위도/경도), 지사 정보 포함
- 초기 화이트리스트: 금융(신한, 삼성, KB 등), IT(네이버, 카카오, 당근 등)
- 어드민 API로 도메인 추가/수정/삭제 가능

[DB 스키마]
```sql
CREATE TABLE company_domains (
    domain_id UUID PRIMARY KEY,
    domain VARCHAR(255) UNIQUE NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    industry VARCHAR(100),
    hq_latitude DECIMAL(10,8),
    hq_longitude DECIMAL(11,8),
    offices JSON, -- [{name: "강남", lat: x, lon: y}, ...]
    whitelisted BOOLEAN DEFAULT true,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

[API 엔드포인트]
- GET /api/v1/admin/company-domains - 목록 조회 (관리자 전용)
- POST /api/v1/admin/company-domains - 추가 (관리자 전용)
- PATCH /api/v1/admin/company-domains/{domain_id} - 수정
- DELETE /api/v1/admin/company-domains/{domain_id} - 삭제

[초기 데이터셋]
금융: shinhan.co.kr, samsung.co.kr, kbfg.com, nh-bank.com, woori.com
IT: naver.com, kakao.com, daangn.com, coupang.com, wemakeprice.com

코드 작성 후 Alembic 마이그레이션 스크립트도 포함해주세요.

---

## 2. 사용자 프로필 및 온보딩 프롬프트

### 2.1 사용자 모델 및 온보딩 API

FastAPI와 SQLAlchemy를 사용하여 lunch-mate 사용자 모델과 온보딩 API를 구현해주세요.

[사용자 정보 구조]
필수:
- user_id (UUID)
- email (unique)
- company_domain
- nickname (unique, 2-15자)
- rating_score (기본값 50)
- is_email_verified

선택:
- team_name, job_title, gender, age_group
- bio, profile_image_url
- company_lat/lon, home_lat/lon
- home_address_level (exact/district/hidden)
- interests (텍스트 배열)

[온보딩 플로우 API]
1. POST /api/v1/onboarding/step1 - 기본 프로필
   요청: {
     "nickname": "마케팅 준호",
     "team_name": "마케팅팀",
     "job_title": "과장"
   }

2. POST /api/v1/onboarding/step2 - 기본 정보
   요청: {
     "gender": "male",
     "age_group": "30s",
     "bio": "스타트업 관심있는 직장인"
   }

3. POST /api/v1/onboarding/step3 - 관심사
   요청: {
     "interests": ["startup", "marketing", "tech"]
   }

4. POST /api/v1/onboarding/step4 - 위치 설정
   요청: {
     "home_lat": 37.4979,
     "home_lon": 127.0276,
     "home_address_level": "exact"
   }

5. POST /api/v1/onboarding/complete - 가입 완료
   응답: {
     "user_id": "uuid",
     "access_token": "jwt",
     "message": "환영합니다!"
   }

[선택사항]
- 각 step별 진행 상태 저장 (Redis 또는 DB)
- Step 스킵 가능 여부 결정
- 프로필 사진 업로드 (S3 통합)

[코드 요구사항]
- SQLAlchemy ORM 모델
- Pydantic 검증 스키마
- 트랜잭션 관리 (모든 step이 완료되어야 계정 활성화)
- 테스트 케이스 (pytest)

마이그레이션 스크립트와 함께 제공해주세요.

### 2.2 프로필 API (조회, 수정, 삭제)

사용자 프로필 관리 API를 FastAPI로 구현해주세요.

[엔드포인트]
1. GET /api/v1/users/me - 현재 사용자 정보 (인증 필수)
2. GET /api/v1/users/{user_id} - 다른 사용자 정보 (공개 범위 적용)
3. PATCH /api/v1/users/me - 프로필 수정
4. DELETE /api/v1/users/me - 계정 삭제 (GDPR 준수)

[정보 공개 계층]
- 닉네임: 모든 사용자 (수정 불가)
- 회사: 같은 회사 사용자만
- 팀/부서: 같은 팀만
- 성별/연령: 선택 공개
- 거주지: 사용자 설정 (정확/구/비공개)
- 매너 점수: 모든 사용자 (평가 기반)

[구현 상세]
- 사용자별 정보 공개 수준 확인 로직
- 프로필 사진 S3 업로드/삭제 (secure signed URL)
- 데이터 삭제 요청 처리 (30일 대기 후 완전 삭제)

JWT 토큰 검증 및 권한 체크 로직도 포함해주세요.

---

## 3. 파티 관련 프롬프트

### 3.1 파티 생성 및 조회 API

FastAPI에서 lunch-mate 파티 생성, 조회, 수정 API를 구현해주세요.

[파티 생성 - POST /api/v1/parties]

요청 본문:
```json
{
  "title": "오늘 12시 강남역 이탈리안 점심 같이 갈 사람!",
  "description": "편한 마음으로 함께해요",
  "location_type": "lunch",
  "restaurant_id": "uuid (선택)",
  "start_time": "2026-02-01T12:00:00Z",
  "duration_minutes": 90,
  "max_participants": 4,
  "preferred_topics": ["startup", "marketing"],
  "age_preference": ["30s", "40s"],
  "gender_preference": "any",
  "cost_range": [15000, 25000]
}
```

응답 (201 Created):
```json
{
  "party_id": "uuid",
  "creator_id": "uuid",
  "status": "recruiting",
  "current_participants": 1,
  "created_at": "2026-02-01T11:45:00Z"
}
```

[파티 조회 - GET /api/v1/parties]

쿼리 파라미터:
- location_type: lunch / dinner / weekend
- latitude, longitude, radius_km: 위치 기반 검색
- start_after: ISO8601 timestamp
- topic_filter: 쉼표 분리 (예: "startup,tech")
- sort_by: created_at (기본), distance, participant_count

응답:
```json
{
  "parties": [
    {
      "party_id": "uuid",
      "title": "...",
      "distance_km": 0.3,
      "start_time": "...",
      "max_participants": 4,
      "current_participants": 2,
      "creator": { "nickname": "...", "rating": 4.8 },
      "status": "recruiting"
    }
  ],
  "total": 45,
  "page": 1
}
```

[파티 상세 조회 - GET /api/v1/parties/{party_id}]

응답에 포함:
- 전체 파티 정보
- 참여자 목록 (닉네임, 회사, 매너 점수만)
- 식당 정보 (이름, 평점, 예상 비용, 지도 링크)
- 생성자 프로필
- 채팅방 링크 (확정 후)

[파티 수정 - PATCH /api/v1/parties/{party_id}]
- 생성자만 수정 가능
- 참여자가 있는 경우 제한 (제목, 설명만 수정)

[상태 관리]
상태 흐름: recruiting → confirmed → completed → [평가]
- recruiting: 모집 중 (시작 1시간 전까지)
- confirmed: 최소 인원 도달 또는 시작 30분 전 자동 확정
- completed: 파티 종료 시간 도달 후 자동 완료

[기술 요구]
- PostgreSQL 지리 쿼리 (PostGIS 사용 또는 간단한 거리 계산)
- 인덱싱 최적화 (start_time, location, status)
- 페이지네이션 (limit: 20 기본)
- 캐싱 (Redis, 5분 TTL)

완전한 구현과 테스트 케이스를 제공해주세요.

### 3.2 파티 참여 및 취소 API

파티 참여 및 취소 기능을 FastAPI로 구현해주세요.

[파티 참가 - POST /api/v1/parties/{party_id}/join]

요청:
- party_id: UUID (경로 매개변수)
- JWT 토큰으로 사용자 확인

응답 (201 Created):
```json
{
  "participant_id": "uuid",
  "party_id": "uuid",
  "user_id": "uuid",
  "joined_at": "2026-02-01T11:50:00Z",
  "current_participants": 3,
  "party_status": "recruiting"
}
```

에러 처리:
- 400: 이미 참가한 경우
- 400: 최대 인원 도달
- 400: 시작 1시간 이내 (참가 불가)
- 400: 낮은 매너 점수 (C등급 이하 경고)
- 403: 신고된 사용자 (D등급)
- 404: 파티 없음

[파티 나가기 - DELETE /api/v1/parties/{party_id}/leave]

응답 (200 OK):
```json
{
  "message": "파티에서 나갔습니다",
  "current_participants": 2
}
```

제약:
- 시작 1시간 전까지만 취소 가능
- 1시간 이내 취소 시 매너 점수 -5점
- 생성자는 나갈 수 없음 (파티 취소만 가능)

[파티 확정 - POST /api/v1/parties/{party_id}/confirm]

자동 트리거:
- 최소 인원(2명) 도달 OR
- 시작 30분 전

수동 트리거:
- 생성자가 명시적으로 확정 요청

응답:
```json
{
  "party_id": "uuid",
  "status": "confirmed",
  "confirmed_at": "2026-02-01T11:30:00Z",
  "chat_room_id": "uuid",
  "message": "파티가 확정되었습니다. 채팅방에 입장하세요."
}
```

[파티 완료 - POST /api/v1/parties/{party_id}/complete]

시스템이 자동 호출:
- start_time + duration_minutes 경과 시

또는 수동 호출:
- 생성자 또는 참여자

응답:
```json
{
  "party_id": "uuid",
  "status": "completed",
  "completed_at": "2026-02-01T13:30:00Z",
  "message": "파티가 종료되었습니다. 평가를 남겨주세요."
}
```

[구현 상세]
- 동시성 제어 (여러 사용자가 동시 참가 시 처리)
- 트랜잭션 관리 (상태 변경 시 원자성 보장)
- 비동기 작업 (채팅방 생성, 푸시 알림 발송)
- 유효성 검사 (시간, 인원, 권한)

Celery 또는 APScheduler를 사용한 자동 상태 변경 로직도 포함해주세요.

### 3.3 파티 위치 기반 검색 (지리 쿼리)

PostgreSQL을 사용하여 위치 기반 파티 검색을 최적화해주세요.

[요구사항]
1. 사용자 위치(lat, lon) 기준 반경 내 파티 검색
2. 회사 위치와 거주 위치 분리 검색
3. 시간 범위 필터 (오늘, 이번주, 선택 날짜)

[구현 옵션]

옵션 1: PostGIS 확장 (권장 - 성능 최적)
```sql
-- 설치
CREATE EXTENSION IF NOT EXISTS postgis;

-- 인덱스
CREATE INDEX idx_parties_location 
ON parties USING GIST (ST_GeomFromText(...));

-- 쿼리: 강남역(37.4979, 127.0276) 반경 1km 이내 파티
SELECT * FROM parties
WHERE ST_DWithin(
  location::geography,
  ST_GeomFromText('POINT(127.0276 37.4979)', 4326)::geography,
  1000 -- 1000 meters
)
AND start_time > NOW()
ORDER BY ST_Distance(location::geography, ...) ASC;
```

옵션 2: 하버사인 공식 (PostgreSQL 기본)
```sql
SELECT *,
  ( 6371 * ACOS(
    COS(RADIANS(90-location_lat)) 
    * COS(RADIANS(90-?)) 
    + SIN(RADIANS(90-location_lat)) 
    * SIN(RADIANS(90-?)) 
    * COS(RADIANS(location_lon-?))
  )) AS distance_km
FROM parties
WHERE status = 'recruiting'
ORDER BY distance_km ASC
LIMIT 20;
```

[FastAPI 구현]

```python
from sqlalchemy import func
from sqlalchemy.sql import text

# 하버사인 거리 계산 함수
def haversine_distance(lat1, lon1, lat2, lon2):
    """
    두 지점 간 거리 (km)
    """
    query = text("""
        SELECT (6371 * ACOS(
          COS(RADIANS(90-:lat2)) 
          * COS(RADIANS(90-:lat1)) 
          + SIN(RADIANS(90-:lat2)) 
          * SIN(RADIANS(90-:lat1)) 
          * COS(RADIANS(:lon2-:lon1))
        )) AS distance
    """)
    return query.bindparams(
        lat1=lat1, lon1=lon1, lat2=lat2, lon2=lon2
    )

@router.get("/api/v1/parties")
async def search_parties(
    latitude: float,
    longitude: float,
    radius_km: float = 1.0,
    location_type: str = "lunch",
    start_after: datetime = None,
    db: Session = Depends(get_db)
):
    """
    위치 기반 파티 검색
    """
    if start_after is None:
        start_after = datetime.now()
    
    query = db.query(Party).filter(
        Party.status == "recruiting",
        Party.start_time >= start_after,
        Party.location_type == location_type
    )
    
    # 거리 계산 및 필터링 (메모리상에서)
    results = []
    for party in query.all():
        dist = calculate_distance(
            latitude, longitude,
            party.location_lat, party.location_lon
        )
        if dist <= radius_km:
            results.append({
                **party.dict(),
                "distance_km": round(dist, 2)
            })
    
    results.sort(key=lambda x: x["distance_km"])
    return {"parties": results[:20], "total": len(results)}
```

[데이터 정규화]
- location_lat, location_lon: DECIMAL(10,8), DECIMAL(11,8)
- 인덱싱: 함께 GIST 인덱스 생성
- 캐싱: Redis에 "주변 파티 (위치, 반경)" 결과 캐시

[성능 요구사항]
- 응답 시간: < 500ms (100K 파티 기준)
- 반경 쿼리: B-tree 또는 R-tree 인덱스 활용

PostGIS 설정과 FastAPI 통합 코드를 모두 제공해주세요.

---

## 4. 채팅 및 실시간 알림 프롬프트

### 4.1 WebSocket 채팅 구현

FastAPI WebSocket을 사용하여 lunch-mate 실시간 채팅을 구현해주세요.

[요구사항]
- 파티 확정 시 자동 채팅방 생성
- 여러 사용자 동시 연결
- 메시지 Redis pub/sub로 브로드캐스트
- 메시지 영속성 (DB 저장)
- 자동 퇴장 (파티 종료 후 30분 또는 사용자 퇴장 시)

[WebSocket 엔드포인트]

ws://localhost:8000/ws/chat/{room_id}?token={jwt_token}

[메시지 포맷]

클라이언트 → 서버:
```json
{
  "type": "message",
  "content": "강남역 3번 출구에서 만나요!",
  "timestamp": "2026-02-01T11:55:00Z"
}
```

서버 → 클라이언트:
```json
{
  "type": "message",
  "sender": {
    "user_id": "uuid",
    "nickname": "마케팅 준호",
    "profile_image": "https://..."
  },
  "content": "강남역 3번 출구에서 만나요!",
  "message_id": "uuid",
  "created_at": "2026-02-01T11:55:00Z"
}
```

시스템 메시지:
```json
{
  "type": "system",
  "content": "마케팅 준호님이 입장했습니다",
  "created_at": "2026-02-01T11:50:00Z"
}
```

[FastAPI 구현 예시]

```python
from fastapi import WebSocket, WebSocketDisconnect
from redis.asyncio import Redis
import json
import asyncio

class ConnectionManager:
    def __init__(self):
        self.active_connections: dict[str, list[WebSocket]] = {}
    
    async def connect(self, room_id: str, websocket: WebSocket):
        await websocket.accept()
        if room_id not in self.active_connections:
            self.active_connections[room_id] = []
        self.active_connections[room_id].append(websocket)
    
    async def disconnect(self, room_id: str, websocket: WebSocket):
        self.active_connections[room_id].remove(websocket)
    
    async def broadcast(self, room_id: str, message: dict):
        for connection in self.active_connections[room_id]:
            try:
                await connection.send_json(message)
            except Exception as e:
                print(f"브로드캐스트 실패: {e}")

manager = ConnectionManager()
redis_client = Redis(host='localhost', port=6379)

@app.websocket("/ws/chat/{room_id}")
async def websocket_endpoint(room_id: str, websocket: WebSocket, token: str):
    # JWT 검증
    user = verify_jwt_token(token)
    if not user:
        await websocket.close(code=4001, reason="Unauthorized")
        return
    
    await manager.connect(room_id, websocket)
    
    # 채팅방 존재 확인
    room = db.query(ChatRoom).filter_by(room_id=room_id).first()
    if not room:
        await websocket.close(code=4004, reason="Room not found")
        return
    
    # 입장 메시지
    await manager.broadcast(room_id, {
        "type": "system",
        "content": f"{user.nickname}님이 입장했습니다",
        "created_at": datetime.now().isoformat()
    })
    
    try:
        while True:
            data = await websocket.receive_json()
            
            # 메시지 저장 (DB)
            message = ChatMessage(
                room_id=room_id,
                sender_id=user.user_id,
                content=data.get("content", "")
            )
            db.add(message)
            db.commit()
            
            # 브로드캐스트
            await manager.broadcast(room_id, {
                "type": "message",
                "sender": {
                    "user_id": user.user_id,
                    "nickname": user.nickname,
                    "profile_image": user.profile_image_url
                },
                "content": data.get("content"),
                "message_id": str(message.message_id),
                "created_at": message.created_at.isoformat()
            })
            
            # Redis에도 저장 (메시지 검색용)
            await redis_client.lpush(f"chat:{room_id}", json.dumps({
                "user_id": user.user_id,
                "content": data.get("content"),
                "timestamp": datetime.now().isoformat()
            }))
    
    except WebSocketDisconnect:
        await manager.disconnect(room_id, websocket)
        await manager.broadcast(room_id, {
            "type": "system",
            "content": f"{user.nickname}님이 나갔습니다"
        })
```

[요구사항]
- 연결 상태 관리 (active connections)
- 메시지 영속성 (PostgreSQL 저장)
- Redis pub/sub으로 확장성 개선 (추후)
- 자동 타임아웃 (30분 유휴)
- 에러 처리 및 재연결 로직

테스트 코드(pytest, pytest-asyncio)도 포함해주세요.

### 4.2 Firebase Cloud Messaging (푸시 알림) 구현

Firebase Cloud Messaging (FCM)을 사용하여 lunch-mate 푸시 알림을 구현해주세요.

[요구사항]
- 파티 확정 시 푸시 알림
- 파티 시작 알림 (15분 전)
- 새 메시지 알림
- 신고/차단 알림
- 배치 발송 (여러 사용자에게 동시)

[Firebase 설정]

1. Firebase 프로젝트 생성
2. 서비스 계정 키 다운로드 (JSON)
3. 환경변수 설정:
   FIREBASE_SERVICE_ACCOUNT_KEY=/path/to/key.json

[FastAPI 구현]

```python
import firebase_admin
from firebase_admin import credentials, messaging
import os

# Firebase 초기화
cred = credentials.Certificate(os.getenv("FIREBASE_SERVICE_ACCOUNT_KEY"))
firebase_admin.initialize_app(cred)

async def send_push_notification(
    user_ids: list[str],
    title: str,
    body: str,
    data: dict = None
):
    """
    여러 사용자에게 푸시 알림 발송
    """
    if not user_ids:
        return {"success": 0, "failure": 0}
    
    message = messaging.MulticastMessage(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        data=data or {},
        android=messaging.AndroidConfig(
            priority="high",
        ),
        apns=messaging.APNSConfig(
            headers={"apns-priority": "10"}
        ),
        webpush=messaging.WebpushConfig(
            notification=messaging.WebpushNotification(
                icon="https://lunch-mate.co.kr/icon.png"
            )
        ),
        tokens=user_ids
    )
    
    response = messaging.send_multicast(message)
    return {
        "success": response.success_count,
        "failure": response.failure_count,
        "responses": response.responses
    }

@app.post("/api/v1/notifications/send")
async def manual_send_notification(
    notification_request: dict,
    current_user: User = Depends(get_current_user)
):
    """
    수동 알림 발송 (테스트용, 관리자만)
    """
    if not current_user.is_admin:
        raise HTTPException(status_code=403, detail="Forbidden")
    
    result = await send_push_notification(
        user_ids=notification_request["user_ids"],
        title=notification_request["title"],
        body=notification_request["body"]
    )
    return result
```

[사용 사례]

1. 파티 확정 알림:
```python
# 파티 확정 시 호출
participants = db.query(PartyParticipant).filter_by(
    party_id=party_id,
    status="joined"
).all()

user_ids = [p.user.fcm_token for p in participants if p.user.fcm_token]

await send_push_notification(
    user_ids=user_ids,
    title="🎉 점심 파티 확정!",
    body="[강남역 이탈리안] 12:00 출발",
    data={
        "party_id": str(party_id),
        "room_id": str(room_id),
        "action": "open_chat"
    }
)
```

2. 파티 시작 알림 (Celery 스케줄):
```python
from celery import shared_task
from celery.schedules import crontab

@shared_task(name="send_party_start_reminders")
def send_party_start_reminders():
    """
    15분 뒤 시작할 파티에 대해 알림 발송
    """
    soon_parties = db.query(Party).filter(
        Party.start_time <= datetime.now() + timedelta(minutes=15),
        Party.start_time > datetime.now(),
        Party.status == "confirmed"
    ).all()
    
    for party in soon_parties:
        participants = db.query(PartyParticipant).filter_by(
            party_id=party.party_id
        ).all()
        
        user_ids = [p.user.fcm_token for p in participants]
        
        await send_push_notification(
            user_ids=user_ids,
            title="⏰ 출발할 시간입니다!",
            body=f"[{party.title}] 15분 뒤 시작",
            data={"party_id": str(party.party_id)}
        )

# Celery Beat 스케줄
app.conf.beat_schedule = {
    'send-party-reminders': {
        'task': 'send_party_start_reminders',
        'schedule': crontab(minute='*/5'),  # 5분마다
    },
}
```

[FCM 토큰 관리]

- 클라이언트: Firebase SDK로 토큰 획득
- 백엔드: 로그인 시 사용자 테이블에 저장
- 갱신: 토큰 변경 시 업데이트 API 호출

[에러 처리]
- 유효하지 않은 토큰: 자동 제거
- 발송 실패: Retry queue (Celery)
- 로깅: Sentry로 추적

Firebase Admin SDK 설정, Celery 통합, 테스트 코드를 모두 제공해주세요.

---

## 5. 평가 및 매너 점수 프롬프트

### 5.1 리뷰 및 매너 점수 계산 시스템

FastAPI에서 파티 후 평가 기능과 매너 점수 시스템을 구현해주세요.

[요구사항]
- 파티 완료 후 참여자 상호 평가
- 1~5점 리커트 척도
- 평가 항목: 친절함, 약속 시간 준수, 흥미로운 대화, 기타
- 평가 기반 매너 점수 자동 계산

[매너 점수 계산식]

점수 = 50 + Σ(평가점수 - 3) × 2

예시:
- 5점 평가 10건 → 50 + (2 × 10) = 70점
- 1점 평가 5건 → 50 + (-4 × 5) = 30점
- 평가 없음 → 50점

[평가 API]

POST /api/v1/reviews
```json
{
  "party_id": "uuid",
  "reviewee_id": "uuid",
  "rating": 5,
  "comment": "매우 친절하고 대화가 재밌습니다!",
  "categories": ["kindness", "punctuality", "interesting_conversation"]
}
```

응답:
```json
{
  "review_id": "uuid",
  "created_at": "2026-02-01T14:00:00Z",
  "reviewee_rating_updated": 72.5,
  "message": "평가가 저장되었습니다"
}
```

GET /api/v1/users/{user_id}/rating
응답:
```json
{
  "user_id": "uuid",
  "rating_score": 72.5,
  "rating_count": 23,
  "grade": "A",
  "breakdown": {
    "5_star": 15,
    "4_star": 6,
    "3_star": 2,
    "2_star": 0,
    "1_star": 0
  },
  "recent_reviews": [
    {
      "reviewer_nickname": "마케팅 미지",
      "rating": 5,
      "comment": "친절하고 좋습니다",
      "created_at": "2026-02-01T14:00:00Z"
    }
  ]
}
```

[SQLAlchemy 모델]

```python
class Review(Base):
    __tablename__ = "reviews"
    
    review_id = Column(UUID, primary_key=True, default=uuid.uuid4)
    party_id = Column(UUID, ForeignKey("parties.party_id"), nullable=False)
    reviewer_id = Column(UUID, ForeignKey("users.user_id"), nullable=False)
    reviewee_id = Column(UUID, ForeignKey("users.user_id"), nullable=False)
    rating = Column(Integer, nullable=False, CheckConstraint("rating BETWEEN 1 AND 5"))
    comment = Column(Text)
    categories = Column(JSON)  # ["kindness", "punctuality", ...]
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    __table_args__ = (
        UniqueConstraint('party_id', 'reviewer_id', 'reviewee_id',
                         name='unique_review_per_party'),
    )
```

[매너 점수 업데이트 로직]

```python
async def recalculate_user_rating(user_id: str, db: Session):
    """
    사용자의 매너 점수 재계산
    """
    reviews = db.query(Review).filter_by(reviewee_id=user_id).all()
    
    if not reviews:
        rating_score = 50
    else:
        total = sum((r.rating - 3) * 2 for r in reviews)
        rating_score = max(0, min(100, 50 + total))
    
    user = db.query(User).filter_by(user_id=user_id).first()
    user.rating_score = rating_score
    user.rating_count = len(reviews)
    db.commit()
    
    # 등급 판정
    if rating_score >= 80:
        grade = "S"
    elif rating_score >= 60:
        grade = "A"
    elif rating_score >= 40:
        grade = "B"
    elif rating_score >= 20:
        grade = "C"
    else:
        grade = "D"
    
    return {"rating_score": rating_score, "grade": grade}
```

[제약 조건]

점수별 제약:
- 80+: 제약 없음
- 60~79: 제약 없음
- 40~59: 제약 없음
- 20~39: 파티 생성 1일 1회, 참가 신청 승인 필요
- <20: 서비스 이용 정지

[구현 상세]
- 평가 수정/삭제 가능 (작성자만, 7일 이내)
- 평가 기반 차단 시스템 (같은 사람 재평가 방지)
- 비매너 유저 자동 탐지 (평가 1점 3회 이상)
- 이의 신청 기능 (평가 부당성 이의)

Celery 백그라운드 작업으로 매너 점수 재계산도 구현해주세요.

### 5.2 신고 및 제제 시스템

신고 시스템과 자동 제제 로직을 FastAPI로 구현해주세요.

[신고 사유]
- "fraud": 부정행위 (거짓 정보)
- "harassment": 성희롱/혐오
- "no_show": 노쇼
- "bad_behavior": 비매너
- "other": 기타

[신고 API]

POST /api/v1/users/{user_id}/report
```json
{
  "reason": "no_show",
  "description": "약속 시간에 나타나지 않음",
  "evidence_url": "s3://bucket/screenshot.png",
  "party_id": "uuid (선택)"
}
```

응답 (201 Created):
```json
{
  "report_id": "uuid",
  "status": "pending",
  "created_at": "2026-02-01T14:00:00Z",
  "message": "신고가 접수되었습니다"
}
```

[신고 처리 프로세스]

1. 자동 필터링 (명백한 사유만 진행)
2. 운영팀 검토 (24시간)
3. 조치 결정:
   - 경고 (1회)
   - 경고 (2회 = 점수 -5)
   - 임시 정지 (3일)
   - 계정 삭제

[운영팀 API]

GET /api/v1/admin/reports?status=pending
- 신고 목록 조회

PATCH /api/v1/admin/reports/{report_id}
```json
{
  "status": "confirmed",
  "action": "warning",
  "admin_comment": "확인됨: 노쇼 인정",
  "sanction_type": "warning"
}
```

[자동 제제 규칙]

신고 누적:
- 경고 3회 → 점수 -5
- 경고 5회 → 임시 정지 (3일)
- 경고 8회 → 계정 삭제 검토

노쇼 방지:
- 노쇼 확인 시 자동 점수 -10
- 누적 3회 → 파티 생성 제한

[SQLAlchemy 모델]

```python
class Report(Base):
    __tablename__ = "reports"
    
    report_id = Column(UUID, primary_key=True, default=uuid.uuid4)
    reporter_id = Column(UUID, ForeignKey("users.user_id"), nullable=False)
    reported_user_id = Column(UUID, ForeignKey("users.user_id"), nullable=False)
    party_id = Column(UUID, ForeignKey("parties.party_id"))
    reason = Column(String, nullable=False)
    description = Column(Text)
    evidence_url = Column(String)
    status = Column(String, default="pending")  # pending, confirmed, rejected, resolved
    admin_comment = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    resolved_at = Column(DateTime)

class Sanction(Base):
    __tablename__ = "sanctions"
    
    sanction_id = Column(UUID, primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID, ForeignKey("users.user_id"), nullable=False)
    report_id = Column(UUID, ForeignKey("reports.report_id"))
    sanction_type = Column(String)  # warning, temp_ban, delete
    duration_days = Column(Integer)  # temp_ban의 경우
    reason = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    expires_at = Column(DateTime)
```

[구현 상세]
- 신고 중복 방지 (같은 쌍에 24시간 1회만)
- 거짓 신고 적발 시 신고자 패널티
- 이의 신청 기능 (7일 이내)
- 제제 현황 사용자에게 알림

전체 워크플로우와 테스트 케이스를 포함해주세요.

---

## 6. 프론트엔드 프롬프트 (Next.js 14)

### 6.1 프로젝트 구조 및 초기 설정

Next.js 14 (App Router)를 기반으로 lunch-mate 프론트엔드를 구축해주세요.

[프로젝트 구조]

```
src/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   │   └── page.tsx
│   │   ├── signup/
│   │   │   └── page.tsx
│   │   └── email-verify/
│   │       └── page.tsx
│   ├── (main)/
│   │   ├── home/
│   │   │   └── page.tsx
│   │   ├── party/
│   │   │   ├── [party_id]/
│   │   │   │   └── page.tsx
│   │   │   └── create/
│   │   │       └── page.tsx
│   │   ├── chat/
│   │   │   └── [room_id]/
│   │   │       └── page.tsx
│   │   ├── profile/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── api/
│   │   └── auth/
│   │       └── route.ts
│   └── layout.tsx
├── components/
│   ├── ui/
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Card.tsx
│   │   └── ...
│   ├── forms/
│   │   ├── LoginForm.tsx
│   │   ├── SignupForm.tsx
│   │   └── PartyCreateForm.tsx
│   ├── party/
│   │   ├── PartyCard.tsx
│   │   ├── PartyList.tsx
│   │   └── PartyDetail.tsx
│   └── chat/
│       ├── ChatWindow.tsx
│       └── ChatMessage.tsx
├── lib/
│   ├── api.ts
│   ├── auth.ts
│   └── validators.ts
├── hooks/
│   ├── useAuth.ts
│   ├── useParties.ts
│   └── useWebSocket.ts
├── types/
│   ├── user.ts
│   ├── party.ts
│   └── chat.ts
└── env.ts
```

[초기 설정 커맨드]

```bash
npx create-next-app@latest lunch-mate --typescript --app

npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

npm install shadcn-ui
npx shadcn-ui@latest init

npm install axios zod zustand date-fns
npm install -D @types/node @types/react
```

[tsconfig.json 설정]

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

[env.local 예시]

```
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_FIREBASE_API_KEY=...
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=...
```

[API 클라이언트 설정]

```typescript
// src/lib/api.ts
import axios from 'axios';
import { getSession } from 'next-auth/react';

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 10000,
});

// 요청 인터셉터: JWT 토큰 추가
api.interceptors.request.use(async (config) => {
  const session = await getSession();
  if (session?.user.accessToken) {
    config.headers.Authorization = `Bearer ${session.user.accessToken}`;
  }
  return config;
});

// 응답 인터셉터: 에러 처리
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // 토큰 갱신 또는 로그아웃
    }
    return Promise.reject(error);
  }
);

export default api;
```

완전한 프로젝트 초기 설정, 디렉토리 구조, 필수 의존성 설치 스크립트를 제공해주세요.

### 6.2 인증 플로우 (이메일 인증 → 프로필 온보딩)

Next.js 14에서 이메일 인증 → 프로필 온보딩 전체 플로우를 구현해주세요.

[페이지 흐름]

1. /login → 이메일 입력
2. /email-verify → 인증 코드 확인
3. /signup → 프로필 정보 입력 (4 단계)
4. /home → 홈 (파티 목록)

[Step 1: 로그인 페이지]

```typescript
// src/app/(auth)/login/page.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import api from '@/lib/api';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleSendEmail = async () => {
    setLoading(true);
    try {
      await api.post('/api/v1/auth/email-verification/send', { email });
      // 인증 코드 페이지로 이동
      router.push(`/email-verify?email=${email}`);
    } catch (error) {
      alert('이메일 발송 실패: ' + error.response?.data?.detail);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="w-full max-w-md">
        <h1 className="text-3xl font-bold mb-8">Lunch-Mate</h1>
        <input
          type="email"
          placeholder="회사 이메일 입력"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full px-4 py-2 border rounded-lg mb-4"
        />
        <button
          onClick={handleSendEmail}
          disabled={loading}
          className="w-full bg-blue-500 text-white py-2 rounded-lg"
        >
          {loading ? '발송 중...' : '인증 코드 발송'}
        </button>
      </div>
    </div>
  );
}
```

[Step 2: 이메일 인증 페이지]

```typescript
// src/app/(auth)/email-verify/page.tsx
'use client';

import { useSearchParams, useRouter } from 'next/navigation';
import { useState } from 'react';
import api from '@/lib/api';

export default function EmailVerifyPage() {
  const searchParams = useSearchParams();
  const email = searchParams.get('email');
  const [code, setCode] = useState('');
  const router = useRouter();

  const handleVerify = async () => {
    try {
      const response = await api.post('/api/v1/auth/email-verification/verify', {
        email,
        code,
      });
      
      // 토큰 저장
      sessionStorage.setItem('temp_token', response.data.temp_token);
      
      // 프로필 입력 페이지로
      router.push('/signup');
    } catch (error) {
      alert('인증 실패');
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="w-full max-w-md">
        <h2 className="text-2xl font-bold mb-6">{email}로 발송된 코드 입력</h2>
        <input
          type="text"
          placeholder="6자리 코드"
          value={code}
          onChange={(e) => setCode(e.target.value)}
          className="w-full px-4 py-2 border rounded-lg mb-4"
          maxLength={6}
        />
        <button
          onClick={handleVerify}
          className="w-full bg-blue-500 text-white py-2 rounded-lg"
        >
          인증
        </button>
      </div>
    </div>
  );
}
```

[Step 3: 프로필 온보딩 (멀티 스텝 폼)]

```typescript
// src/app/(auth)/signup/page.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import api from '@/lib/api';

type OnboardingStep = 'basic' | 'info' | 'interests' | 'location';

export default function SignupPage() {
  const [step, setStep] = useState<OnboardingStep>('basic');
  const [formData, setFormData] = useState({
    nickname: '',
    teamName: '',
    jobTitle: '',
    gender: '',
    ageGroup: '',
    bio: '',
    interests: [],
    homeLat: null,
    homeLon: null,
  });

  const router = useRouter();
  const tempToken = sessionStorage.getItem('temp_token');

  const handleNextStep = () => {
    const steps: OnboardingStep[] = ['basic', 'info', 'interests', 'location'];
    const currentIndex = steps.indexOf(step);
    if (currentIndex < steps.length - 1) {
      setStep(steps[currentIndex + 1]);
    }
  };

  const handleComplete = async () => {
    try {
      await api.post('/api/v1/auth/signup', formData, {
        headers: { Authorization: `Bearer ${tempToken}` },
      });
      
      // 로그인 처리 (next-auth 또는 custom)
      router.push('/home');
    } catch (error) {
      alert('가입 실패');
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="w-full max-w-md">
        <h2 className="text-2xl font-bold mb-6">프로필 설정</h2>
        <p className="text-gray-500 mb-4">Step {['basic', 'info', 'interests', 'location'].indexOf(step) + 1} / 4</p>

        {step === 'basic' && (
          <div>
            <input
              placeholder="닉네임"
              value={formData.nickname}
              onChange={(e) => setFormData({ ...formData, nickname: e.target.value })}
              className="w-full px-4 py-2 border rounded-lg mb-4"
            />
            <input
              placeholder="팀/부서 (선택)"
              value={formData.teamName}
              onChange={(e) => setFormData({ ...formData, teamName: e.target.value })}
              className="w-full px-4 py-2 border rounded-lg mb-4"
            />
          </div>
        )}

        {step === 'info' && (
          <div>
            <select
              value={formData.gender}
              onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
              className="w-full px-4 py-2 border rounded-lg mb-4"
            >
              <option value="">성별 선택</option>
              <option value="male">남성</option>
              <option value="female">여성</option>
              <option value="other">기타</option>
            </select>
          </div>
        )}

        {step === 'interests' && (
          <div>
            <label className="block mb-4">
              <input type="checkbox" value="startup" /> 스타트업
            </label>
          </div>
        )}

        <button
          onClick={step === 'location' ? handleComplete : handleNextStep}
          className="w-full bg-blue-500 text-white py-2 rounded-lg"
        >
          {step === 'location' ? '가입 완료' : '다음'}
        </button>
      </div>
    </div>
  );
}
```

[Zustand 상태 관리]

```typescript
// src/lib/store.ts
import { create } from 'zustand';

interface AuthState {
  user: any | null;
  token: string | null;
  setUser: (user: any) => void;
  setToken: (token: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  token: null,
  setUser: (user) => set({ user }),
  setToken: (token) => set({ token }),
  logout: () => set({ user: null, token: null }),
}));
```

[훅 작성]

```typescript
// src/hooks/useAuth.ts
import { useAuthStore } from '@/lib/store';
import api from '@/lib/api';

export function useAuth() {
  const { user, token, setUser, setToken, logout } = useAuthStore();

  const login = async (email: string, code: string) => {
    const response = await api.post('/api/v1/auth/email-verification/verify', {
      email,
      code,
    });
    setToken(response.data.access_token);
  };

  return { user, token, login, logout };
}
```

완전한 멀티 스텝 폼, 상태 관리, API 통합 코드를 제공해주세요.

### 6.3 파티 목록 및 검색 UI

Next.js 14 + shadcn/ui를 사용하여 파티 목록과 위치 기반 검색을 구현해주세요.

[페이지: /home]

```typescript
// src/app/(main)/home/page.tsx
'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useGeolocation } from '@/hooks/useGeolocation';
import PartyCard from '@/components/party/PartyCard';
import PartyFilters from '@/components/party/PartyFilters';
import api from '@/lib/api';

interface Party {
  party_id: string;
  title: string;
  start_time: string;
  max_participants: number;
  current_participants: number;
  distance_km: number;
  creator: {
    nickname: string;
    rating: number;
  };
}

export default function HomePage() {
  const [parties, setParties] = useState<Party[]>([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState({
    locationType: 'lunch',
    radiusKm: 1.0,
    sortBy: 'created_at',
  });

  const { latitude, longitude } = useGeolocation();
  const router = useRouter();

  useEffect(() => {
    if (!latitude || !longitude) return;

    const fetchParties = async () => {
      setLoading(true);
      try {
        const response = await api.get('/api/v1/parties', {
          params: {
            latitude,
            longitude,
            location_type: filters.locationType,
            radius_km: filters.radiusKm,
            sort_by: filters.sortBy,
          },
        });
        setParties(response.data.parties);
      } catch (error) {
        console.error('파티 조회 실패:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchParties();
  }, [latitude, longitude, filters]);

  if (loading) return <div>로딩 중...</div>;

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold">🍽️ 점심 파티 찾기</h1>
        <button
          onClick={() => router.push('/party/create')}
          className="bg-blue-500 text-white px-4 py-2 rounded-lg"
        >
          + 파티 만들기
        </button>
      </div>

      <PartyFilters filters={filters} setFilters={setFilters} />

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-6">
        {parties.map((party) => (
          <PartyCard
            key={party.party_id}
            party={party}
            onClick={() => router.push(`/party/${party.party_id}`)}
          />
        ))}
      </div>

      {parties.length === 0 && (
        <div className="text-center py-12">
          <p className="text-gray-500">근처에 파티가 없습니다</p>
        </div>
      )}
    </div>
  );
}
```

[파티 카드 컴포넌트]

```typescript
// src/components/party/PartyCard.tsx
import { formatDistance } from 'date-fns';
import { ko } from 'date-fns/locale';

interface PartyCardProps {
  party: {
    party_id: string;
    title: string;
    start_time: string;
    max_participants: number;
    current_participants: number;
    distance_km: number;
    creator: { nickname: string; rating: number };
  };
  onClick: () => void;
}

export default function PartyCard({ party, onClick }: PartyCardProps) {
  return (
    <div
      onClick={onClick}
      className="border rounded-lg p-4 hover:shadow-lg cursor-pointer transition"
    >
      <h3 className="font-bold text-lg mb-2">{party.title}</h3>
      
      <div className="flex items-center justify-between mb-3 text-sm text-gray-600">
        <span>⏰ {formatDistance(new Date(party.start_time), new Date(), { locale: ko })}</span>
        <span>📍 {party.distance_km.toFixed(1)}km</span>
      </div>

      <div className="flex items-center justify-between mb-3">
        <span className="text-sm">
          👥 {party.current_participants}/{party.max_participants}명
        </span>
        <span className="text-sm text-blue-600 font-bold">
          ⭐ {party.creator.rating.toFixed(1)}
        </span>
      </div>

      <p className="text-xs text-gray-500">{party.creator.nickname}</p>
    </div>
  );
}
```

[필터 컴포넌트]

```typescript
// src/components/party/PartyFilters.tsx
'use client';

export default function PartyFilters({ filters, setFilters }) {
  return (
    <div className="flex gap-4 p-4 bg-gray-100 rounded-lg">
      <select
        value={filters.locationType}
        onChange={(e) =>
          setFilters({ ...filters, locationType: e.target.value })
        }
        className="px-4 py-2 border rounded-lg"
      >
        <option value="lunch">점심</option>
        <option value="dinner">저녁</option>
        <option value="weekend">주말</option>
      </select>

      <select
        value={filters.radiusKm}
        onChange={(e) =>
          setFilters({ ...filters, radiusKm: parseFloat(e.target.value) })
        }
        className="px-4 py-2 border rounded-lg"
      >
        <option value="0.5">500m 이내</option>
        <option value="1.0">1km 이내</option>
        <option value="2.0">2km 이내</option>
        <option value="5.0">5km 이내</option>
      </select>

      <select
        value={filters.sortBy}
        onChange={(e) =>
          setFilters({ ...filters, sortBy: e.target.value })
        }
        className="px-4 py-2 border rounded-lg"
      >
        <option value="created_at">최신순</option>
        <option value="distance">거리순</option>
        <option value="participant_count">인기순</option>
      </select>
    </div>
  );
}
```

[위치 기반 훅]

```typescript
// src/hooks/useGeolocation.ts
import { useEffect, useState } from 'react';

export function useGeolocation() {
  const [coords, setCoords] = useState<{
    latitude: number | null;
    longitude: number | null;
  }>({ latitude: null, longitude: null });

  useEffect(() => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setCoords({
            latitude: position.coords.latitude,
            longitude: position.coords.longitude,
          });
        },
        (error) => console.error('위치 권한 거부:', error)
      );
    }
  }, []);

  return coords;
}
```

완전한 파티 목록 페이지, 카드 컴포넌트, 필터링 로직을 제공해주세요.

---

## 7. 배포 및 운영 프롬프트

### 7.1 Docker 및 Kubernetes 배포

lunch-mate의 프로덕션 환경을 위한 Docker 및 Kubernetes 설정을 작성해주세요.

[Dockerfile - FastAPI 백엔드]

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# 의존성 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 소스코드
COPY . .

# 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

[Dockerfile - Next.js 프론트엔드]

```dockerfile
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY package*.json ./
RUN npm install --production

EXPOSE 3000
CMD ["npm", "start"]
```

[docker-compose.yml]

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: lunch_mate
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql://admin:password@postgres:5432/lunch_mate
      REDIS_URL: redis://redis:6379
    depends_on:
      - postgres
      - redis

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      NEXT_PUBLIC_API_URL: http://localhost:8000

volumes:
  postgres_data:
```

[Kubernetes 배포 (k8s/)]

```yaml
# k8s/backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: lunch-mate-backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: lunch-mate-backend
  template:
    metadata:
      labels:
        app: lunch-mate-backend
    spec:
      containers:
      - name: backend
        image: lunch-mate-backend:latest
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: url
        - name: REDIS_URL
          valueFrom:
            configMapKeyRef:
              name: redis-config
              key: url
        resources:
          requests:
            memory: "256Mi"
            cpu: "500m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: lunch-mate-backend-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8000
  selector:
    app: lunch-mate-backend
```

[Helm Chart (선택)]

```yaml
# helm/values.yaml
backend:
  image: lunch-mate-backend:latest
  replicas: 3
  resources:
    requests:
      memory: "256Mi"
      cpu: "500m"

postgres:
  enabled: true
  size: 10Gi

redis:
  enabled: true
```

[배포 커맨드]

```bash
# Docker Compose로 개발 환경 실행
docker-compose up -d

# Kubernetes 배포
kubectl apply -f k8s/

# Helm으로 배포 (선택)
helm install lunch-mate ./helm
```

전체 Docker/K8s 설정 파일, Helm Chart 구조를 제공해주세요.

### 7.2 모니터링 및 로깅 설정

Datadog, Sentry, ELK 스택을 사용한 모니터링 및 로깅을 설정해주세요.

[Sentry 설정 - FastAPI]

```python
import sentry_sdk
from sentry_sdk.integrations.fastapi import FastApiIntegration

sentry_sdk.init(
    dsn=os.getenv("SENTRY_DSN"),
    integrations=[FastApiIntegration()],
    traces_sample_rate=0.1,
    profiles_sample_rate=0.1,
)

app = FastAPI()
```

[Sentry 설정 - Next.js]

```typescript
// next.config.js
const withSentryConfig = require("@sentry/nextjs").withSentryConfig;

module.exports = withSentryConfig(
  {
    // Next.js config
  },
  {
    org: "lunch-mate",
    project: "frontend",
  }
);
```

[Datadog 에이전트 설정]

```dockerfile
FROM python:3.11-slim

# Datadog Agent 설치
RUN pip install datadog-checks-base

COPY datadog/ /etc/datadog-agent/checks.d/
```

[구성 파일: datadog-agent.yaml]

```yaml
api_key: ${DD_API_KEY}
app_key: ${DD_APP_KEY}

logs:
  enabled: true

logs_config:
  - type: file
    path: /var/log/app.log
    service: lunch-mate-backend
    source: python
```

[ELK 스택 - docker-compose]

```yaml
elasticsearch:
  image: docker.elastic.co/elasticsearch/elasticsearch:8.0.0
  environment:
    - discovery.type=single-node
    - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
  ports:
    - "9200:9200"

kibana:
  image: docker.elastic.co/kibana/kibana:8.0.0
  ports:
    - "5601:5601"
  environment:
    - ELASTICSEARCH_HOSTS=http://elasticsearch:9200

logstash:
  image: docker.elastic.co/logstash/logstash:8.0.0
  volumes:
    - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
```

[로깅 설정 - FastAPI]

```python
import logging
from pythonjsonlogger import jsonlogger

# JSON 로깅
logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter()
logHandler.setFormatter(formatter)
logger = logging.getLogger()
logger.addHandler(logHandler)
logger.setLevel(logging.INFO)
```

[커스텀 미터릭]

```python
from prometheus_client import Counter, Histogram, start_http_server

party_created = Counter('party_created_total', 'Total parties created')
party_duration = Histogram('party_duration_seconds', 'Party duration in seconds')

# 메트릭 집계
start_http_server(8001)  # Prometheus 메트릭 엔드포인트
```

[알림 규칙]

```yaml
# alerting_rules.yml
groups:
  - name: lunch-mate
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 5m
        annotations:
          summary: "High error rate detected"
          
      - alert: APILatency
        expr: histogram_quantile(0.95, http_request_duration_seconds) > 1
        for: 10m
        annotations:
          summary: "High API latency"
```

전체 모니터링 스택 설정, 커스텀 메트릭, 알림 구성을 제공해주세요.

---

## 마무리

이 프롬프트 가이드를 섹션별로 Claude Code에 붙여넣으면, 각 기능을 체계적으로 구현할 수 있습니다.

**추천 순서**:
1. 인증 시스템 (Section 1, 2)
2. 파티 모델 및 API (Section 3)
3. 채팅 (Section 4)
4. 평가 시스템 (Section 5)
5. 프론트엔드 (Section 6)
6. 배포 (Section 7)

각 섹션별로 필요한 의존성, 설정, 테스트 케이스가 모두 포함되어 있습니다.
