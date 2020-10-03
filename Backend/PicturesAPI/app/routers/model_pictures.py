from typing import List

from fastapi import APIRouter, File, Depends, UploadFile, status
from sqlalchemy.orm import Session
from app import services, actions, models, schemas
from app.database.db import SessionLocal, engine, Base
from app.settings import MODEL_UPLOAD_FOLDER

router = APIRouter()
picture_service = services.PictureService()
model_picture_actions = actions.ModelPictureActions()
history_actions = actions.HistoryActions()
face_shape_service = services.FaceShapeService()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/", status_code=status.HTTP_201_CREATED)
async def upload_model_picture(file: UploadFile = File(...), db: Session = Depends(get_db)):
    save_path = MODEL_UPLOAD_FOLDER

    print(save_path)

    file_name = picture_service.save_picture(file, save_path)
    face_detected = picture_service.detect_face(file_name, save_path)

    if face_detected is True:
        # try to find face landmark points
        face_landmarks = picture_service.detect_face_landmarks(file_name, save_path)
        if face_landmarks is None:
            return {"No face landmarks detected"}
        else:
            picture_info = picture_service.get_picture_info(save_path, file_name)
            print(picture_info, "Picture info")

            # detect face_shape
            face_shape = picture_service.detect_face_shape(file_name, save_path)
            if (face_shape is None):
                print("face shape is none")
                return {"face shape detected"}
            print(face_shape, "face_shape result")
            print(type(face_shape))

            # add model picture to db
            # fake face shape id
            face_shape_id = 1
            new_picture = models.ModelPicture(file_name=picture_info[1], file_path=picture_info[0],
                                         file_size=picture_info[2], height=picture_info[3],
                                         width=picture_info[4], face_shape_id=face_shape_id)

            return face_shape[0]
    else:
        return {"No face detected (cant read image)"}


@router.get("/", response_model=List[schemas.ModelPicture])
def read_model_pictures(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    model_pictures = model_picture_actions.read_models(db, skip=skip, limit=limit)
    return model_pictures