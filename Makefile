.PHONY: help install dev up down logs clean migrate test

help:
	@echo "Lunch-Mate 개발 명령어"
	@echo ""
	@echo "  make install    - 프론트엔드/백엔드 의존성 설치"
	@echo "  make dev        - 개발 서버 실행 (frontend + backend)"
	@echo "  make up         - Docker 컨테이너 실행 (PostgreSQL + Redis)"
	@echo "  make down       - Docker 컨테이너 중지"
	@echo "  make logs       - Docker 로그 확인"
	@echo "  make clean      - Docker 볼륨 포함 정리"
	@echo "  make migrate    - Alembic 마이그레이션 실행"
	@echo "  make test       - 테스트 실행"

# 의존성 설치
install:
	cd frontend && npm install
	cd backend && pip install -r requirements.txt

# Docker 명령어
up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

clean:
	docker-compose down -v

# 개발 서버
dev-frontend:
	cd frontend && npm run dev

dev-backend:
	cd backend && uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

dev:
	@echo "터미널 2개에서 각각 실행하세요:"
	@echo "  make dev-frontend"
	@echo "  make dev-backend"

# 마이그레이션
migrate:
	cd backend && alembic upgrade head

migrate-new:
	@read -p "마이그레이션 메시지: " msg; \
	cd backend && alembic revision --autogenerate -m "$$msg"

# 테스트
test:
	cd backend && pytest
	cd frontend && npm test

# 린트
lint:
	cd frontend && npm run lint
	cd backend && ruff check src/
