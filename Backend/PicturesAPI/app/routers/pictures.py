from fastapi import APIRouter, File, Depends, UploadFile, status
from sqlalchemy.orm import Session
from app import services, actions, models
from app.database.db import SessionLocal, engine, Base


router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/pictures", status_code=status.HTTP_201_CREATED)
async def upload_picture(file: UploadFile = File(...), db: Session = Depends(get_db)):
    picture_service = services.PictureService()

    file_name = picture_service.save_picture(file)
    # return {file_name}

    face_detected = picture_service.detect_face(file_name)
    if face_detected is True:
        # crop picture and save in preprocessed folder
        # picture_service.crop_picture(file_name)
        # add picture to db

        face_landmarks = picture_service.detect_face_landmarks('pictures/original/' + file_name)
        # Prevent to add to db if landmarks not found
        if face_landmarks is None:
            return {"No face detected (landmarks)"}
        else:
            picture_info = picture_service.get_picture_info('pictures/original/', file_name)
            print(picture_info)
            new_picture = models.Picture(file_name=picture_info[1], file_path=picture_info[0],
                                         file_size=picture_info[2], height=picture_info[3], width=picture_info[4])
            picture_actions = actions.PictureActions()
            picture_actions.add_picture(db=db, picture=new_picture)
            # detect face_shape
            face_shape = picture_service.detect_face_shape(file_name)
            return face_shape
    else:
        return {"No face detected (cant read image)"}
    # return face_detected


@router.get("/pictures/{picture_id}")
async def read_picture(picture_id: int):
    pass

