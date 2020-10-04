from typing import List

from fastapi import APIRouter, File, Depends, UploadFile, status, Response
from sqlalchemy.orm import Session
from app import services, actions, models, schemas
from app.database.db import SessionLocal, engine, Base
from app.settings import PICTURE_UPLOAD_FOLDER, MODEL_UPLOAD_FOLDER

router = APIRouter()
picture_service = services.PictureService()
picture_actions = actions.PictureActions()
history_actions = actions.HistoryActions()
face_shape_service = services.FaceShapeService()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/pictures", status_code=status.HTTP_201_CREATED)
async def upload_picture(file: UploadFile = File(...), db: Session = Depends(get_db)):
    save_path = PICTURE_UPLOAD_FOLDER

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

            new_picture = models.Picture(file_name=picture_info.file_name, file_path=picture_info.file_path,
                                         file_size=picture_info.file_size, height=picture_info.height,
                                         width=picture_info.width)

            orig_pic = picture_actions.add_picture(db=db, picture=new_picture)

            # Testing how to create a history record after detecting a face shape
            # create History instance

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


@router.get("/{picture_id}", response_model=schemas.Picture)
async def read_picture(picture_id: int, db: Session = Depends(get_db)):
    return picture_actions.read_picture_by_id(db, picture_id=picture_id)


"""
This route is not deemed necessary at the moment
In order to retrieve a picture by its filename, you may search for it through the GET /pictures?search=filename route

@router.get("/{picture_filename}", status_code=status.HTTP_200_OK, response_model=schemas.Picture)
async def read_picture_by_filename(picture_filename: str, response: Response, db: Session = Depends(get_db)):
    result = picture_actions.read_picture_by_file_name(db, file_name=picture_filename)

    if not result:
        response.status_code = status.HTTP_404_NOT_FOUND

    return result
"""


@router.get("/", response_model=List[schemas.Picture])
def read_pictures(skip: int = 0, limit: int = 100, search: str = "", db: Session = Depends(get_db)):
    pictures = picture_actions.read_pictures(db, skip=skip, limit=limit, search=search)
    return pictures


@router.get("/models/", response_model=List[schemas.Picture])
def read_model_pictures(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    pictures = picture_actions.read_models(db, skip=skip, limit=limit)
    return pictures


# @router.post("/change_face_shape")
# def change_face_shape(picture_id: int, new_face_shape: str, db: Session = Depends(get_db())):
#     selected_picture_history = history_actions.rea


@router.post("/{picture_id}/hair_colour")
async def change_hair_colour(picture_id: int, colour: str, db: Session = Depends(get_db)):
    selected_picture = picture_actions.read_picture_by_id(db, picture_id=picture_id)
    print(selected_picture.file_name)
    print(selected_picture.file_path)

    # apply selected colour
    picture_info = picture_service.change_hair_colour(file_name=selected_picture.file_name, selected_colour=colour,
                                                      file_path=selected_picture.file_path)
    print(picture_info)

    # create new picture and add to db
    new_picture = models.Picture(file_name=picture_info[1], file_path=picture_info[0],
                                 file_size=picture_info[2], height=picture_info[3], width=picture_info[4])

    mod_pic = picture_actions.add_picture(db=db, picture=new_picture)

    # fake user_id
    user_id = 1

    # create new history record and add to db
    # ToDo: fix history logic
    new_history = models.History(picture_id=mod_pic.id, original_picture_id=selected_picture.id, hair_colour_id=1,
                                 user_id=user_id)

    history_actions.add_history(db=db, history=new_history)

    return new_picture

    # # ToDo: After hair color picture is generated, we need to:
    # # 1. create new Picture (add picture to db)
    # # 2. Create new history (add history to db)
    #
    # new_picture = models.Picture(file_name=picture_info[1], file_path=picture_info[0],
    #                              file_size=picture_info[2], height=picture_info[3], width=picture_info[4])
    #
    #
    #
    # history_actions = actions.HistoryActions()
    #
    # new_history = models.History(picture_id=picture_id, original_picture_id=orig_pic.id, face_shape_id=face_shape_id,
    #                              user_id=user_id)
    # print(new_history)
    # print(new_history.picture_id)
    # history_actions.add_history(db=db, history=new_history)
    # print(new_history)
    #
    #
    #
    # colour_id = 55
    # history_actions.change_hair_colour(db, picture_id=picture_id, colour_id=colour_id)
    # # return picture_actions.read_picture_by_id(db, picture_id=picture_id)


@router.post("/{user_picture_id}/change_hairstyle/{model_picture_id}")
async def change_hairstyle(user_picture_id: int, model_picture_id: int, db: Session = Depends(get_db)):
    user_picture = picture_actions.read_picture_by_id(db, picture_id=user_picture_id)
    model_picture = picture_actions.read_picture_by_id(db, picture_id=model_picture_id)

    # apply hair transfer
    picture_info = picture_service.change_hairstyle(user_picture=user_picture, model_picture=model_picture)
    print(picture_info)

    # create new picture and add to db
    new_picture = models.Picture(file_name=picture_info[1], file_path=picture_info[0],
                                 file_size=picture_info[2], height=picture_info[3], width=picture_info[4])

    mod_pic = picture_actions.add_picture(db=db, picture=new_picture)

    # fake user_id
    user_id = 1

    # create new history record and add to db
    # ToDo: fix history logic
    new_history = models.History(picture_id=mod_pic.id, original_picture_id=user_picture.id, hair_style_id=1,
                                 user_id=user_id)

    history_actions.add_history(db=db, history=new_history)


@router.post("_str/{user_picture_file_name}/change_hairstyle/{model_picture_file_name}")
async def change_hairstyle_str(user_picture_file_name: str, model_picture_file_name: str,
                               db: Session = Depends(get_db)):
    # user_picture = picture_actions.read_picture_by_id(db, picture_id=user_picture_id)
    # model_picture = picture_actions.read_picture_by_id(db, picture_id=model_picture_id)

    picture_service.change_hairstyle_str(user_picture=user_picture_file_name, model_picture=model_picture_file_name)


@router.post("/{user_picture_id}/change_hairstyle/{model_picture_id}")
async def change_hairstyle(user_picture_id: int, model_picture_id: int, db: Session = Depends(get_db)):
    user_picture = picture_actions.read_picture_by_id(db, picture_id=user_picture_id)
    model_picture = picture_actions.read_picture_by_id(db, picture_id=model_picture_id)

    picture_service.change_hairstyle(user_picture=user_picture, model_picture=model_picture)


@router.delete("/{picture_id}", status_code=status.HTTP_200_OK)
async def delete_picture(picture_id: int, response: Response, db: Session = Depends(get_db)):
    """
    DELETE /pictures/{picture_id}
    :param db: db session instance
    :param response: response object
    :param picture_id: ID of the picture record to be deleted from the database
    """
    if not db.query(models.Picture).filter(models.Picture.id == picture_id).first():
        response.status_code = status.HTTP_404_NOT_FOUND

    return picture_actions.delete_picture(db=db, picture_id=picture_id)
