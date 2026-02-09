# Lunch-Mate (런치메이트)

직장인 전용 점심 약속 매칭 플랫폼, **Lunch-Mate**입니다.
이 프로젝트는 **Flutter** 기반의 모바일 앱과 **FastAPI** 기반의 백엔드로 구성되어 있습니다.

## 🛠 기술 스택 (Tech Stack)

### Mobile App (Frontend)
- **Framework**: Flutter (Dart)
- **State Management**: Flutter Riverpod
- **Navigation**: GoRouter
- **Maps**: Kakao Map Plugin
- **UI**: Shadcn UI (Flutter Port), Google Fonts
- **Network**: Dio, Flutter Dotenv

### Backend
- **Framework**: FastAPI (Python 3.10+)
- **Database ORM**: SQLAlchemy (Async)
- **Migrations**: Alembic
- **Validation**: Pydantic
- **Formatting/Linting**: Ruff

### Infrastructure & Database
- **Database**: PostgreSQL
- **Cache**: Redis
- **Containerization**: Docker & Docker Compose

---

## 📂 프로젝트 구조 (Project Structure)

```
lunch-mate/
├── app/                # Flutter 모바일 애플리케이션 소스 코드
│   ├── lib/            # Dart 코드 (UI, 상태 관리, 로직)
│   ├── pubspec.yaml    # Flutter 의존성 관리
│   └── .env            # 앱 환경 변수 (API 키 등)
├── backend/            # FastAPI 백엔드 소스 코드
│   ├── src/            # Python 소스 코드 (API, 모델, 스키마)
│   ├── alembic/        # DB 마이그레이션 스크립트
│   └── requirements.txt # Python 의존성 관리
├── docker-compose.yml  # DB(PostgreSQL), Redis 컨테이너 설정
├── Makefile            # 프로젝트 실행 및 관리 명령어
└── README.md           # 프로젝트 문서
```

---

## 🚀 시작하기 (Getting Started)

### 1. 사전 요구사항 (Prerequisites)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 설치
- [Python 3.10+](https://www.python.org/downloads/) 설치
- [Docker](https://www.docker.com/) 및 Docker Compose 설치

### 2. 환경 변수 설정 (Environment Setup)
`app/.env` 파일을 생성하고 필요한 API 키를 설정해야 합니다.

**app/.env 예시:**
```env
KAKAO_NATIVE_APP_KEY=your_kakao_native_app_key
KAKAO_JS_API_KEY=your_kakao_js_api_key
KAKAO_REST_API_KEY=your_kakao_rest_api_key
```

### 3. 설치 및 실행 (Installation & Running)

프로젝트 루트에서 `make` 명령어를 사용하여 간편하게 실행할 수 있습니다.

#### 의존성 설치
```bash
make install
```

#### 인프라(DB) 실행
Docker를 이용하여 PostgreSQL과 Redis를 실행합니다.
```bash
make up
```
*중지하려면 `make down`, 데이터까지 초기화하려면 `make clean`을 사용하세요.*

#### 데이터베이스 마이그레이션
백엔드 DB 스키마를 최신 상태로 업데이트합니다.
```bash
make migrate
```

#### 개발 서버 실행
터미널을 2개 열어서 백엔드와 앱을 각각 실행하는 것을 권장합니다.

**Terminal 1 (Backend):**
```bash
make dev-backend
```
*Swagger 문서: http://localhost:8000/docs*

**Terminal 2 (App):**
```bash
make dev-app
```

---

## ✅ 테스트 및 린트 (Test & Lint)

### 테스트 실행
백엔드와 앱의 테스트 코드를 실행합니다.
```bash
make test
```

### 코드 분석 (Lint)
코드 스타일 및 잠재적인 오류를 검사합니다.
```bash
make lint
```
