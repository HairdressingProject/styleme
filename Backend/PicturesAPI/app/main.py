from fastapi import FastAPI, APIRouter
from app.database.db import SessionLocal, engine, Base

from app.routers import pictures
from app.routers import test

Base.metadata.create_all(bind=engine)

app = FastAPI()

api_router = APIRouter()
api_router.include_router(pictures.router, tags=["Pictures"])
api_router.include_router(test.router, tags=["test"])

app.include_router(api_router)
