from typing import List
import os
import pathlib
from fastapi import APIRouter, File, Depends, UploadFile, status, Response
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

    if not os.path.exists(os.path.join(pathlib.Path().absolute() / save_path)):
        os.makedirs(os.path.join(pathlib.Path().absolute() / save_path))

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
            hair_style_id = 1
            hair_colour_id = 1
            hair_length_id = 1
            new_model_picture = models.ModelPicture(file_name=picture_info.file_name, file_path=picture_info.file_path,
                                                    file_size=picture_info.file_size, height=picture_info.height,
                                                    width=picture_info.width,
                                                    face_shape_id=face_shape_id, hair_style_id=hair_style_id,
                                                    hair_length_id=hair_length_id, hair_colour_id=hair_colour_id)

            model_picture_actions.add_model_picture(db=db, picture=new_model_picture)

            return face_shape[0]
    else:
        return {"No face detected (cant read image)"}


@router.get("/", response_model=List[schemas.ModelPicture])
def get_model_pictures(skip: int = 0, limit: int = 100, search: str = "", db: Session = Depends(get_db)):
    model_pictures = model_picture_actions.read_model_pictures(db, skip=skip, limit=limit, search=search)
    return model_pictures


@router.get("/{model_picture_id}", response_model=schemas.ModelPicture)
def get_model_picture(model_picture_id: int, db: Session = Depends(get_db)):
    return model_picture_actions.read_model_picture_by_id(db, picture_id=model_picture_id)
    return model_pictures

@router.delete("/{model_picture_id}", status_code=status.HTTP_200_OK)
async def delete_picture(model_picture_id: int, response: Response, db: Session = Depends(get_db)):
    """
    DELETE /models/{model_picture_id}
    :param db: db session instance
    :param response: response object
    :param model_picture_id: ID of the model picture record to be deleted from the database
    """
    print(" *************** DELETE PICTURE *************************")
    if not db.query(models.ModelPicture).filter(models.ModelPicture.id == model_picture_id).first():
        response.status_code = status.HTTP_404_NOT_FOUND

    # get the selected model picture
    selected_picture = model_picture_actions.read_model_picture_by_id(db, model_picture_id)
    print(selected_picture.file_path + selected_picture.file_name)

    # delete the selected model picture from disk
    picture_service.delete_picture(selected_picture.file_path, selected_picture.file_name)

    return model_picture_actions.delete_model_picture(db=db, model_picture_id=model_picture_id)
