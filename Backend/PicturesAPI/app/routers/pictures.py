from typing import List

from fastapi import APIRouter, File, Depends, UploadFile, status
from sqlalchemy.orm import Session
from app import services, actions, models, schemas
from app.database.db import SessionLocal, engine, Base
from app.settings import PICTURE_UPLOAD_FOLDER

router = APIRouter()
picture_service = services.PictureService()
picture_actions = actions.PictureActions()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/pictures", status_code=status.HTTP_201_CREATED)
async def upload_picture(file: UploadFile = File(...), db: Session = Depends(get_db)):

    save_path = PICTURE_UPLOAD_FOLDER

    file_name = picture_service.save_picture(file, save_path)
    face_detected = picture_service.detect_face(file_name, save_path)

    if face_detected is True:
        # try to find face landmark points
        face_landmarks = picture_service.detect_face_landmarks(file_name, save_path)
        if face_landmarks is None:
            return {"No face landmarks detected"}
        else:
            picture_info = picture_service.get_picture_info(file_name, save_path)
            print(picture_info, "Picture info")
            new_picture = models.Picture(file_name=picture_info[1], file_path=picture_info[0],
                                         file_size=picture_info[2], height=picture_info[3], width=picture_info[4])

            picture_actions.add_picture(db=db, picture=new_picture)
            # detect face_shape
            face_shape = picture_service.detect_face_shape(file_name, save_path)
            return face_shape
    else:
        return {"No face detected (cant read image)"}
    # return face_detected


@router.get("/pictures/{picture_id}", response_model=schemas.Picture)
async def read_picture(picture_id: int, db: Session = Depends(get_db)):
    return picture_actions.read_picture_by_id(db, picture_id=picture_id)


@router.get("/pictures/", response_model=List[schemas.Picture])
def read_pictures(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    pictures = picture_actions.read_pictures(db, skip=skip, limit=limit)
    return pictures


@router.get("/pictures/{picture_id}/hair_colour")
async def change_hair_colour(picture_id: int, db: Session = Depends(get_db)):
    selected_picture = picture_actions.read_picture_by_id(db, picture_id=picture_id)
    print(selected_picture.file_name)
    print(selected_picture.file_path)

    picture_service.change_hair_colour(file_name=selected_picture.file_name, file_path=selected_picture.file_path)
    # return picture_actions.read_picture_by_id(db, picture_id=picture_id)

