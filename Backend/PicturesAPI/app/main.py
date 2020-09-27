from fastapi import FastAPI, File, Depends, UploadFile
from sqlalchemy.orm import Session
from app.database.db import SessionLocal, engine
from app import services

app = FastAPI()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/pictures/upload")
async def save_picture(file: UploadFile = File(...), db: Session = Depends(get_db)):
    picture_service = services.PictureService()
    file_info = picture_service.save_picture(file)
    return {file_info}

@app.get("/pictures/detect_face")
async def detect_face(file_name: str):
    picture_service = services.PictureService()
    face_detected = picture_service.detect_face(file_name)
    return face_detected

@app.get("/test")
async def test():
    return {"Test OK"}