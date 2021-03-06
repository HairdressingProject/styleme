from typing import List, Optional, Union
import os
import pathlib
from fastapi import APIRouter, File, Depends, UploadFile, status, Response, HTTPException
from sqlalchemy.orm import Session
from app import services, actions, models, schemas
from app.database.db import SessionLocal, engine, Base
from app.settings import MODEL_UPLOAD_FOLDER
from fastapi.responses import FileResponse, ORJSONResponse

router = APIRouter()
picture_service = services.PictureService()
model_picture_actions = actions.ModelPictureActions()
face_shape_actions = actions.FaceShapeActions()
history_actions = actions.HistoryActions()
hair_length_actions = actions.HairLengthActions()
hair_style_actions = actions.HairStyleActions()
face_shape_service = services.FaceShapeService()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("", status_code=status.HTTP_201_CREATED)
async def upload_model_picture(hair_length: Optional[str] = None, hair_length_id: Optional[int] = None,
                               hair_style_id: Optional[int] = None, hair_style: Optional[str] = None,
                               file: UploadFile = File(...), db: Session = Depends(get_db)):
    """
    Upload a model picture. IF picture is valid, the face shape is detected, a new record is added to the model
    pictures table and the picture file is saved
    :param hair_length: hair length name of model picture
    :param hair_length_id: hair length id of the model picture
    :param hair_style_id: hair style id of the model picture
    :param hair_style: hair style name of the model picture
    :param file: model picture file to be uploaded
    :param db: db session instance
    :return: json object that contains the model picture information, the detected face shape, hair length and hair
    style information

    """
    if not hair_length_id and not hair_length:
        raise HTTPException(status_code=400, detail='Please provide either a valid hair_length or hair_length_id')
    if not hair_style_id and not hair_style:
        raise HTTPException(status_code=400, detail='Please provide either a valid hair_style or hair_style_id')

    hair_length_results: Union[models.HairLength, List[models.HairLength], None] = None
    hair_style_results: Union[models.HairStyle, List[models.HairStyle], None] = None

    if hair_length_id:
        hair_length_results = hair_length_actions.get_hair_length(db=db, hair_length_id=hair_length_id)
    else:
        hair_length_results = hair_length_actions.get_hair_lengths(db=db, limit=1, search=hair_length.strip())

    if hair_style_id:
        hair_style_results = hair_style_actions.get_hair_style(db=db, hair_style_id=hair_style_id)
    else:
        hair_style_results = hair_style_actions.get_hair_styles(db=db, limit=1, search=hair_style.strip())

    if hair_length_results and hair_style_results:
        if isinstance(hair_length_results, list):
            if len(hair_length_results):
                hair_length_results = hair_length_results[0]

        if isinstance(hair_style_results, list):
            if len(hair_style_results):
                hair_style_results = hair_style_results[0]

        hair_length_results_id: int = hair_length_results.id
        hair_style_results_id: int = hair_style_results.id
        save_path = MODEL_UPLOAD_FOLDER

        if not os.path.exists(os.path.join(pathlib.Path().absolute() / save_path)):
            os.makedirs(os.path.join(pathlib.Path().absolute() / save_path))

        file_name = picture_service.save_picture(file, save_path)
        face_detected = picture_service.detect_face(file_name, save_path)

        if face_detected:
            # try to find face landmark points
            face_landmarks = picture_service.detect_face_landmarks(file_name, save_path)
            if face_landmarks is None:
                raise HTTPException(status_code=422, detail='No face landmarks detected')
            else:
                picture_info = picture_service.get_picture_info(save_path, file_name)

                # detect face_shape
                face_shape = picture_service.detect_face_shape(face_landmarks, file_name, save_path)
                if face_shape is None:
                    raise HTTPException(status_code=422, detail='Face shape could not be detected')

                # add model picture to db
                face_shape_results = face_shape_actions.get_face_shapes(db=db, limit=1, search=face_shape[0])

                if len(face_shape_results):
                    face_shape_detected: models.FaceShape = face_shape_results[0]

                    new_model_picture = models.ModelPicture(file_name=picture_info.file_name,
                                                            file_path=picture_info.file_path,
                                                            file_size=picture_info.file_size,
                                                            height=picture_info.height,
                                                            width=picture_info.width,
                                                            face_shape_id=face_shape_detected.id)

                    results = model_picture_actions.add_model_picture(db=db, picture=new_model_picture)

                    new_model_picture = schemas.ModelPictureUpdate(id=results.id, face_shape_id=face_shape_detected.id,
                                                                   hair_length_id=hair_length_results.id,
                                                                   hair_style_id=hair_style_results_id)

                    updated_model_picture = model_picture_actions.update_model_picture(db=db,
                                                                                       model_picture_id=new_model_picture.id,
                                                                                       model_picture=new_model_picture)

                    face_shape_detected = face_shape_actions.get_face_shape(db=db,
                                                                            face_shape_id=updated_model_picture.face_shape_id)

                    hair_length_results = hair_length_actions.get_hair_length(db=db,
                                                                              hair_length_id=hair_length_results_id)

                    hair_style_results = hair_style_actions.get_hair_style(db=db, hair_style_id=hair_style_results_id)
                    return {'model_picture': updated_model_picture, 'face_shape': face_shape_detected,
                            'hair_length': hair_length_results, 'hair_style': hair_style_results}
                else:
                    raise HTTPException(status_code=404,
                                        detail='Could not find face shape that matches results from the script')
        else:
            raise HTTPException(status_code=422, detail='Could not detect faces from the image')
    raise HTTPException(status_code=404, detail='Hair length or hair style not found')


@router.put("/{model_picture_id}", status_code=status.HTTP_200_OK)
async def update_model_picture(model_picture_id: int, model_picture: schemas.ModelPictureUpdate,
                               response: Response, db: Session = Depends(get_db)):
    """
    PUT /models/{model_picture_id}
    :param model_picture_id: ID of the model picture record to be updated
    :param model_picture: ModelPictureUpdate instance to be updated in the database
    :param response: response object
    :param db: db session instance
    :return:
    """
    if model_picture_id != model_picture.id:
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {
            "message": "Model picture ID in the endpoint does not match the one sent in the request body"
        }

    if not db.query(models.ModelPicture).filter(models.ModelPicture.id == model_picture_id).first():
        response.status_code = status.HTTP_404_NOT_FOUND
        return {
            "message": "Model picture entry not found"
        }

    return model_picture_actions.update_model_picture(db=db, model_picture_id=model_picture_id,
                                                      model_picture=model_picture)


@router.get("", response_model=List[schemas.ModelPicture])
def get_model_pictures(skip: int = 0, limit: int = 100, search: str = "", db: Session = Depends(get_db)):
    """
    Read all model pictures from db
    :param skip: optionally skip a number of records (default = 0)
    :param limit: optionally limit the number of results retrieved (default = 1000)
    :param search: optionally search history records by username (default = "")
    :param db: db session instance
    :return: List of ModelPicture class instances
    """
    model_pictures = model_picture_actions.read_model_pictures(db, skip=skip, limit=limit, search=search)
    return model_pictures


@router.get("/id/{model_picture_id}", response_model=schemas.ModelPicture)
def get_model_picture(model_picture_id: int, db: Session = Depends(get_db)):
    """
    Get a model picture identified by it's id
    :param model_picture_id: ID of the model picture
    :param db: db session instance
    :return: instance of ModelPicture class that matches the ID
    """
    model_picture: models.ModelPicture = model_picture_actions.read_model_picture_by_id(db=db,
                                                                                        model_picture_id=model_picture_id)

    if not model_picture:
        raise HTTPException(status_code=404, detail='Model picture not found by ID')
    return model_picture_actions.read_model_picture_by_id(db, model_picture_id=model_picture_id)


@router.get("/file/{model_picture_id}", status_code=status.HTTP_200_OK)
async def read_model_picture_file(model_picture_id: int, db: Session = Depends(get_db)):
    """
    Get a model picture File object identified by it's picture ID
    :param model_picture_id: ID of the picture
    :param db: db session instance
    :return: Binary File
    """
    selected_picture = model_picture_actions.read_model_picture_by_id(model_picture_id=model_picture_id, db=db)
    if selected_picture:
        file_path = selected_picture.file_path + selected_picture.file_name
        if os.path.exists(file_path):
            return FileResponse(file_path)
    raise HTTPException(status_code=404, detail='Picture file not found')


@router.delete("/{model_picture_id}", status_code=status.HTTP_200_OK)
async def delete_picture(model_picture_id: int, response: Response, db: Session = Depends(get_db)):
    """
    DELETE /models/{model_picture_id}
    :param db: db session instance
    :param response: response object
    :param model_picture_id: ID of the model picture record to be deleted from the database
    """
    if not db.query(models.ModelPicture).filter(models.ModelPicture.id == model_picture_id).first():
        raise HTTPException(status_code=404, detail='Model picture not found by ID')

    # get the selected model picture
    selected_picture = model_picture_actions.read_model_picture_by_id(db, model_picture_id)

    # delete the selected model picture from disk
    picture_service.delete_picture(selected_picture.file_path, selected_picture.file_name)

    return model_picture_actions.delete_model_picture(db=db, model_picture_id=model_picture_id)
