from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from src.config import settings
from src.core.database import init_db
from src.auth.router import router as auth_router
from src.users.router import router as users_router
from src.parties.router import router as parties_router
from src.chat.router import router as chat_router
from src.reviews.router import router as reviews_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    await init_db()
    yield
    # Shutdown


app = FastAPI(
    title=settings.APP_NAME,
    description="직장인 점심 약속 매칭 플랫폼",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(auth_router, prefix=settings.API_V1_PREFIX)
app.include_router(users_router, prefix=settings.API_V1_PREFIX)
app.include_router(parties_router, prefix=settings.API_V1_PREFIX)
app.include_router(chat_router, prefix=settings.API_V1_PREFIX)
app.include_router(reviews_router, prefix=settings.API_V1_PREFIX)


@app.get("/")
async def root():
    return {"message": "런치메이트 API", "docs": "/docs"}


@app.get("/health")
async def health():
    return {"status": "healthy"}
