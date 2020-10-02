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

            # detect face_shape
            face_shape = picture_service.detect_face_shape(file_name, save_path)
            if (face_shape is None):
                print("face shape is none")
                return {"face shape detected"}
            print(face_shape, "face_shape result")
            print(type(face_shape))

            new_picture = models.Picture(file_name=picture_info[1], file_path=picture_info[0],
                                         file_size=picture_info[2], height=picture_info[3], width=picture_info[4])

            orig_pic = picture_actions.add_picture(db=db, picture=new_picture)

            # Testing how to create a history record after detecting a face shape
            # create History instance
            history_actions = actions.HistoryActions()
            face_shape_service = services.FaceShapeService()

            # parse face shape string to int
            face_shape_id = face_shape_service.parse_face_shape(face_shape[0])
            print(face_shape_id)

            user_id = 1

            # ToDo: redirect to POST /history/face_shape ?
            new_history = models.History(picture_id=orig_pic.id, original_picture_id=orig_pic.id,
                                         face_shape_id=face_shape_id, user_id=user_id)
            print(new_history)
            print(new_history.picture_id)
            history_actions.add_history(db=db, history=new_history)
            print(new_history)

            return face_shape[0]
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
async def change_hair_colour(picture_id: int, colour: str, db: Session = Depends(get_db)):
    selected_picture = picture_actions.read_picture_by_id(db, picture_id=picture_id)
    print(selected_picture.file_name)
    print(selected_picture.file_path)

    picture_service.change_hair_colour(file_name=selected_picture.file_name, selected_colour=colour,
                                       file_path=selected_picture.file_path)
    # return picture_actions.read_picture_by_id(db, picture_id=picture_id)


@router.get("/pictures/{user_picture_id}/change_hairstyle/{model_picture_id}")
async def change_hairstyle(user_picture_id: int, model_picture_id: int, db: Session = Depends(get_db)):
    user_picture = picture_actions.read_picture_by_id(db, picture_id=user_picture_id)
    model_picture = picture_actions.read_picture_by_id(db, picture_id=model_picture_id)

    picture_service.change_hairstyle(user_picture=user_picture, model_picture=model_picture)


@router.get("/pictures_str/{user_picture_id}/change_hairstyle/{model_picture_id}")
async def change_hairstyle_str(user_picture_id: str, model_picture_id: str, db: Session = Depends(get_db)):
    # user_picture = picture_actions.read_picture_by_id(db, picture_id=user_picture_id)
    # model_picture = picture_actions.read_picture_by_id(db, picture_id=model_picture_id)

    picture_service.change_hairstyle_str(user_picture=user_picture_id, model_picture=model_picture_id)
