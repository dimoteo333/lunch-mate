.PHONY: help install dev up down logs clean migrate test lint

# Directory definitions
BACKEND_DIR = backend
APP_DIR = app

help:
	@echo "Lunch-Mate 개발 명령어"
	@echo ""
	@echo "  make install    - 백엔드 및 앱 의존성 설치"
	@echo "  make dev        - 통합 개발 환경 안내"
	@echo "  make dev-backend - 백엔드 서버 실행 (FastAPI)"
	@echo "  make dev-app     - 앱 실행 (Flutter)"
	@echo "  make up         - Docker 컨테이너 실행 (PostgreSQL + Redis)"
	@echo "  make down       - Docker 컨테이너 중지"
	@echo "  make logs       - Docker 로그 확인"
	@echo "  make clean      - Docker 볼륨 포함 정리"
	@echo "  make migrate    - Alembic 마이그레이션 실행"
	@echo "  make test       - 테스트 실행 (Backend & App)"
	@echo "  make lint       - Lint 실행 (Ruff & Flutter Analyze)"

# Dependency installation
install:
	@echo "의존성 설치 중..."
	cd $(BACKEND_DIR) && pip install -r requirements.txt
	cd $(APP_DIR) && flutter pub get

# Docker commands
up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

clean:
	docker-compose down -v

# Development servers
dev-backend:
	cd $(BACKEND_DIR) && uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

dev-app:
	cd $(APP_DIR) && flutter run

dev:
	@echo "터미널 2개에서 각각 실행하세요:"
	@echo "  make dev-backend"
	@echo "  make dev-app"

# Database migrations
migrate:
	cd $(BACKEND_DIR) && alembic upgrade head

migrate-new:
	@read -p "마이그레이션 메시지: " msg; \
	cd $(BACKEND_DIR) && alembic revision --autogenerate -m "$$msg"

# Testing
test:
	@echo "백엔드 테스트 실행..."
	cd $(BACKEND_DIR) && pytest
	@echo "앱 테스트 실행..."
	cd $(APP_DIR) && flutter test

# Linting
lint:
	@echo "백엔드 Lint (Ruff) 실행..."
	cd $(BACKEND_DIR) && ruff check src/
	@echo "앱 Lint (Flutter Analyze) 실행..."
	cd $(APP_DIR) && flutter analyze

