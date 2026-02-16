# Lunch-Mate (런치메이트)

직장인 전용 점심 약속 매칭 플랫폼, **Lunch-Mate**입니다.
**Flutter** 기반 모바일 앱과 **FastAPI** 기반 백엔드로 구성되어 있으며,
**Triad Orchestration System**을 통한 멀티 에이전트 개발 워크플로우를 적용합니다.

---

## 주요 기능

| 기능 | 설명 |
|---|---|
| **기업 이메일 인증** | 회사 이메일 기반 가입/로그인 (6자리 인증 코드) |
| **점심 파티 생성** | 제목, 시간, 장소, 인원 설정으로 파티 생성 |
| **위치 기반 매칭** | GPS + Kakao Map으로 주변 파티 탐색 (리스트/지도 듀얼 뷰) |
| **실시간 채팅** | WebSocket 기반 파티 내 실시간 메시징 |
| **장소 검색** | Kakao Local API로 키워드/카테고리 기반 음식점 검색 |
| **Glassmorphic UI** | Liquid Glass 애니메이션 + 반투명 디자인 시스템 |

---

## 기술 스택

### Mobile App (Flutter)

| Category | Technology |
|---|---|
| **Framework** | Flutter 3.10+ (Dart 3.0+) |
| **State Management** | Riverpod 2.5+ (StateNotifier, FutureProvider) |
| **Routing** | GoRouter 13+ (선언적 라우팅) |
| **Data Models** | Freezed 2.4+ + json_serializable (불변 모델) |
| **HTTP Client** | Dio 5.4+ (Interceptors, JWT 자동 첨부) |
| **Real-time** | web_socket_channel 2.4+ (WebSocket 채팅) |
| **UI System** | shadcn_ui 0.45+ + Custom Glassmorphic Widgets |
| **Maps** | Kakao Map Plugin 0.4+ |
| **Storage** | FlutterSecureStorage (토큰), SharedPreferences (설정) |
| **Fonts** | Google Fonts (Noto Sans KR) |

### Backend (FastAPI)

| Category | Technology |
|---|---|
| **Framework** | FastAPI (Python 3.10+) |
| **ORM** | SQLAlchemy (Async) |
| **Migrations** | Alembic |
| **Validation** | Pydantic v2 |
| **Linting** | Ruff |

### Infrastructure

| Category | Technology |
|---|---|
| **Database** | PostgreSQL |
| **Cache** | Redis |
| **Containerization** | Docker & Docker Compose |

---

## 프로젝트 구조

```
lunch-mate/
├── CLAUDE.md              # Triad Orchestration 공유 규칙 (immutable)
├── AGENTS.md              # 에이전트 페르소나 정의
├── README.md              # 프로젝트 문서 (이 파일)
├── Makefile               # 빌드/실행 자동화
├── docker-compose.yml     # DB(PostgreSQL), Redis 컨테이너 설정
│
├── docs/                  # 프로젝트 문서
│   ├── CONTEXT.json       # 워크플로우 상태 (Single Source of Truth)
│   ├── PRD.md             # 제품 요구사항 정의서
│   ├── ARCHITECTURE.md    # 시스템 아키텍처 문서
│   ├── DECISIONS.md       # 아키텍처 결정 기록 (ADR)
│   ├── CHANGELOG.md       # 변경 이력
│   └── logs/              # 아카이브된 reasoning logs
│
├── app/                   # Flutter 모바일 앱
│   ├── lib/
│   │   ├── main.dart      # 앱 진입점
│   │   ├── app.dart       # ShadApp.router 루트 위젯
│   │   ├── core/          # 상수, 라우터, 테마
│   │   │   ├── constants/ # API 엔드포인트, 앱 상수
│   │   │   ├── router/    # GoRouter 라우트 정의
│   │   │   └── theme/     # Glassmorphic 테마 시스템
│   │   ├── data/          # 데이터 레이어
│   │   │   ├── models/    # Freezed 불변 모델 (User, Party, Chat)
│   │   │   ├── providers/ # Dio, SecureStorage 인프라
│   │   │   └── repositories/ # API 접근 추상화
│   │   ├── providers/     # Riverpod 상태 관리
│   │   │   ├── auth_provider.dart     # 인증 상태
│   │   │   ├── party_provider.dart    # 파티 CRUD
│   │   │   ├── chat_provider.dart     # WebSocket 채팅
│   │   │   └── location_provider.dart # GPS 위치
│   │   └── presentation/  # UI 레이어
│   │       ├── auth/      # 로그인, 인증, 온보딩
│   │       ├── home/      # 홈 (리스트/지도 뷰)
│   │       ├── party/     # 파티 생성, 상세, 식당 검색
│   │       ├── chat/      # 실시간 채팅
│   │       ├── profile/   # 프로필
│   │       └── widgets/   # 공유 위젯 (GlassCard, GlassAppBar 등)
│   ├── test/              # Flutter 테스트
│   └── pubspec.yaml       # Flutter 의존성
│
└── backend/               # FastAPI 백엔드
    ├── src/               # Python 소스 코드
    ├── alembic/           # DB 마이그레이션
    └── requirements.txt   # Python 의존성
```

---

## 아키텍처

### Flutter App - Clean Architecture

```
Presentation (Screens/Widgets)
        │ ref.watch()
        ▼
Providers (Riverpod StateNotifier/FutureProvider)
        │
        ▼
Repositories (API 추상화)
        │
        ▼
Infrastructure (Dio HTTP / WebSocket / SecureStorage)
```

### 라우팅

| Route | Screen | Description |
|---|---|---|
| `/login` | LoginScreen | 이메일 입력 |
| `/verify` | VerifyScreen | 인증 코드 입력 |
| `/onboarding` | OnboardingScreen | 4단계 프로필 설정 |
| `/home` | HomeScreen | 파티 목록/지도 (메인) |
| `/party/create` | PartyCreateScreen | 파티 생성 폼 |
| `/party/create/search-restaurant` | RestaurantSearchScreen | 식당 검색 |
| `/party/:id` | PartyDetailScreen | 파티 상세 정보 |
| `/chat/:roomId` | ChatScreen | 실시간 채팅 |
| `/profile` | ProfileScreen | 프로필 관리 |

### 디자인 시스템 (Glassmorphism)

| Component | Description |
|---|---|
| `LiquidBackground` | 3색 애니메이션 블롭 배경 (Blue/Purple/Indigo) |
| `GlassCard` | BackdropFilter + 반투명 카드 |
| `GlassAppBar` | Pill 형태 투명 앱바 (공유 위젯) |
| `GlassBottomNavBar` | 반투명 하단 네비게이션 |
| `GradientText` | 그라데이션 텍스트 효과 |
| `PulsingDot` | 맥동 인디케이터 |

---

## Triad Orchestration System

이 프로젝트는 **context-trio** 기반의 멀티 에이전트 개발 워크플로우를 적용합니다.

### 에이전트 구성

| Agent | Model | Role |
|---|---|---|
| **Architect** | Claude Opus 4.6 | 설계, 태스크 분해, 프롬프트 엔지니어링 |
| **Implementer** | GLM-4.7 | Flutter/Dart 구현, 테스트 작성 |
| **Auditor** | Claude Opus 4.6 | 코드 리뷰, 보안 감사, 문서 관리 |

### 워크플로우

```
Planning (Architect) → Implementation (Implementer) → Review (Auditor)
                                                           │
                                               ┌──────────┤
                                               ▼          ▼
                                           Approved    Rejected
                                               │          │
                                               ▼          ▼
                                             Done     Re-planning
```

### 주요 문서

| File | Description | Owner |
|---|---|---|
| `CLAUDE.md` | 시스템 규칙 (immutable) | System |
| `AGENTS.md` | 에이전트 페르소나 | Architect |
| `docs/CONTEXT.json` | 워크플로우 상태 (SSoT) | Shared |
| `docs/PRD.md` | 제품 요구사항 | Architect |
| `docs/ARCHITECTURE.md` | 시스템 아키텍처 | Architect |
| `docs/DECISIONS.md` | 아키텍처 결정 기록 | Architect |
| `docs/CHANGELOG.md` | 변경 이력 | Auditor |

---

## 시작하기

### 1. 사전 요구사항

- [Flutter SDK 3.10+](https://docs.flutter.dev/get-started/install)
- [Python 3.10+](https://www.python.org/downloads/)
- [Docker](https://www.docker.com/) & Docker Compose

### 2. 환경 변수 설정

`app/.env` 파일을 생성합니다:

```env
KAKAO_NATIVE_APP_KEY=your_kakao_native_app_key
KAKAO_JS_API_KEY=your_kakao_js_api_key
KAKAO_REST_API_KEY=your_kakao_rest_api_key
```

### 3. 설치 및 실행

```bash
# 의존성 설치
make install

# 인프라(DB) 실행
make up

# 데이터베이스 마이그레이션
make migrate

# 개발 서버 실행 (Terminal 1: Backend)
make dev-backend
# Swagger 문서: http://localhost:8000/docs

# 개발 서버 실행 (Terminal 2: App)
make dev-app
```

중지: `make down` / 데이터 초기화: `make clean`

### 4. 코드 생성 (Freezed)

Freezed 모델 변경 시 코드 생성이 필요합니다:

```bash
cd app && flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 테스트 및 린트

```bash
# 테스트 실행
make test

# 코드 분석
make lint
```

---

## API 엔드포인트

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/auth/verify` | 인증 코드 발송 |
| POST | `/api/v1/auth/verify/confirm` | 인증 코드 확인 |
| GET | `/api/v1/users/me` | 현재 사용자 정보 |
| PUT | `/api/v1/users/onboarding` | 온보딩 완료 |
| GET | `/api/v1/parties` | 파티 목록 (위치 기반) |
| POST | `/api/v1/parties` | 파티 생성 |
| GET | `/api/v1/parties/:id` | 파티 상세 |
| POST | `/api/v1/parties/:id/join` | 파티 참여 |
| POST | `/api/v1/parties/:id/leave` | 파티 나가기 |
| GET | `/api/v1/chat/:roomId/messages` | 채팅 메시지 조회 |
| WS | `/ws/chat/:roomId` | 실시간 채팅 |

---

## Known Issues

| ID | Severity | Description | Status |
|---|---|---|---|
| ISSUE-001 | Minor | WebSocket 재연결 로직 미구현 | Open |
| ISSUE-002 | Minor | Token refresh 401 처리 스텁 | Open |
| ISSUE-003 | Info | 채팅 메시지 페이지네이션 미구현 | Open |
| ISSUE-004 | Info | 파티 취소 기능 스텁 | Open |
| ISSUE-005 | Info | 홈 화면 필터 기능 미구현 | Open |
