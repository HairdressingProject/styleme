from datetime import datetime
from typing import List, Optional, Union

from fastapi import APIRouter, File, Depends, UploadFile, status, Response, HTTPException
from sqlalchemy.orm import Session
from app import services, actions, models, schemas
from app.database.db import SessionLocal, engine, Base
from app.settings import PICTURE_UPLOAD_FOLDER, MODEL_UPLOAD_FOLDER
from fastapi.responses import FileResponse, ORJSONResponse

router = APIRouter()
picture_service = services.PictureService()
picture_actions = actions.PictureActions()
history_actions = actions.HistoryActions()
hair_colour_actions = actions.HairColourActions()
model_picture_actions = actions.ModelPictureActions()
face_shape_actions = actions.FaceShapeActions()
face_shape_service = services.FaceShapeService()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("", status_code=status.HTTP_201_CREATED)
async def upload_picture(file: UploadFile = File(...), db: Session = Depends(get_db)):
    save_path = PICTURE_UPLOAD_FOLDER
    file_name = picture_service.save_picture(file, save_path)
    face_detected = picture_service.detect_face(file_name, save_path)

    if face_detected is True:
        # try to find face landmark points
        face_landmarks = picture_service.detect_face_landmarks(file_name, save_path)
        if face_landmarks is None:
            raise HTTPException(status_code=422, detail="No face landmarks detected")
        else:
            picture_info = picture_service.get_picture_info(save_path, file_name)

            # detect face_shape
            face_shape = picture_service.detect_face_shape(file_name, save_path)
            if face_shape is None:
                raise HTTPException(status_code=422, detail="Face shape could not be detected")

            new_picture = models.Picture(file_name=picture_info.file_name, file_path=picture_info.file_path,
                                         file_size=picture_info.file_size, height=picture_info.height,
                                         width=picture_info.width)

            orig_pic = picture_actions.add_picture(db=db, picture=new_picture)

            # Testing how to create a history record after detecting a face shape
            # create History instance

            # parse face shape string to int
            face_shape_id = face_shape_service.parse_face_shape(face_shape[0])

            face_shape_detected: models.FaceShape = face_shape_actions.get_face_shape(db=db, id=face_shape_id)

            user_id = 1

            # ToDo: redirect to POST /history/face_shape ?
            new_history = models.History(picture_id=orig_pic.id, original_picture_id=orig_pic.id,
                                         face_shape_id=face_shape_id, user_id=user_id)
            new_history_entry: models.History = history_actions.add_history(db=db, history=new_history)

            results = picture_actions.read_picture_by_file_name(db=db, file_name=new_picture.file_name, limit=1)
            return {'picture': results[0], 'face_shape': face_shape[0], 'history_entry': new_history_entry}
    else:
        raise HTTPException(status_code=422, detail="No face detected")


@router.get("/file/{picture_id}", status_code=status.HTTP_200_OK)
async def read_picture_file(picture_id: int, db: Session = Depends(get_db)):
    selected_picture = picture_actions.read_picture_by_id(picture_id=picture_id, db=db)
    if selected_picture:
        file_path = selected_picture.file_path + '/' + selected_picture.file_name
        print(file_path)
        return FileResponse(file_path)
    raise HTTPException(status_code=404, detail='Picture file not found')


@router.get("/id/{picture_id}", response_model=schemas.Picture)
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


@router.get("", response_model=List[schemas.Picture])
def read_pictures(skip: int = 0, limit: int = 100, search: str = "", db: Session = Depends(get_db)):
    pictures = picture_actions.read_pictures(db, skip=skip, limit=limit, search=search)
    return pictures


@router.get("/face_shape/{picture_id}")
async def get_picture_face_shape(picture_id: int, db: Session = Depends(get_db)):
    """Get face shape from a picture identified by its ID
    :param picture_id: ID of the picture to be processed
    :param db: db session instance
    :returns: Computed face shape
    :raises:
        HTTPException: Status 422 if no face is detected from the picture, 404 if the picture is not found by its ID
    """
    picture = picture_actions.read_picture_by_id(picture_id=picture_id, db=db)

    if picture:
        face_detected = picture_service.detect_face(picture.file_name, picture.file_path)

        if face_detected is True:
            # try to find face landmark points
            face_landmarks = picture_service.detect_face_landmarks(picture.file_name, picture.file_path)
            if face_landmarks is None:
                raise HTTPException(status_code=422, detail="Could not detect face landmarks from picture")
            else:
                picture_info = picture_service.get_picture_info(picture.file_path, picture.file_name)
                print(picture_info, "Picture info")

                # detect face_shape
                face_shape = picture_service.detect_face_shape(picture.file_name, picture.file_path)
                if face_shape is None:
                    print("face shape is none")
                    return {"face shape detected"}
                print(face_shape, "face_shape result")
                print(type(face_shape))
            try:
                return {'face_shape': face_shape[0]}
            except:
                raise HTTPException(status_code=422, detail="Could not compute face shape from picture")
        raise HTTPException(status_code=422, detail="Could not detect a face in the picture")
    raise HTTPException(status_code=404, detail="Could not find picture by id")


@router.get("/change_hair_colour/{picture_id}", status_code=status.HTTP_200_OK, response_class=ORJSONResponse)
async def change_hair_colour(picture_id: int, colour: str, r: int, g: int, b: int, db: Session = Depends(get_db)):
    """Applies changes to hair colour based on a base colour name (e.g. hot pink) and RGB values, which vary by lightness
    :param picture_id: ID of the picture to be processed
    :param db: db session instance
    :param colour: Base hair colour name
    :param r: Red channel of the colour
    :param g: Green channel of the colour
    :param b: Blue channel of the colour
    :returns: New picture object and history entry reflecting changes
    """

    selected_picture = picture_actions.read_picture_by_id(db, picture_id=picture_id)

    # get hair colour
    hair_colour_results: List[models.HairColour] = hair_colour_actions.get_hair_colours(db=db, search=colour,
                                                                                        limit=1)
    if len(hair_colour_results):
        hair_colour = hair_colour_results[0]

        # get user
        user: models.User = history_actions.get_user_id_from_picture_id(db=db, picture_id=picture_id)
        if user:
            # apply selected colour
            picture_info = picture_service.change_hair_colour(file_name=selected_picture.file_name,
                                                              selected_colour=hair_colour.colour_name,
                                                              r=r, g=g, b=b,
                                                              file_path=selected_picture.file_path)
            print(picture_info)

            picture_info.file_name = picture_info.file_name + f'_{datetime.now().timestamp()}'

            # create new picture and add to db
            new_picture = models.Picture(file_name=picture_info.file_name, file_path=picture_info.file_path,
                                         file_size=picture_info.file_size, height=picture_info.height,
                                         width=picture_info.width)

            mod_pic: models.Picture = picture_actions.add_picture(db=db, picture=new_picture)

            hair_colour = hair_colour_results[0]
            new_history = models.History(picture_id=mod_pic.id, original_picture_id=selected_picture.id,
                                         hair_colour_id=hair_colour.id,
                                         user_id=user.id)
            history_entry: models.History = history_actions.add_history(db=db, history=new_history)
            mod_pic: models.Picture = picture_actions.read_picture_by_id(picture_id=history_entry.picture_id, db=db)
            return {"picture": mod_pic, "history_entry": history_entry}
        raise HTTPException(status_code=404, detail='No user associated with this picture ID was found')
    raise HTTPException(status_code=404, detail='No hair colour record associated with this colour name was found')


@router.get("/change_hair_style", status_code=status.HTTP_200_OK)
async def change_hairstyle(user_picture_id: Optional[int] = None, model_picture_id: Optional[int] = None,
                           user_picture_file_name: Optional[str] = None, model_picture_file_name: Optional[str] = None,
                           db: Session = Depends(get_db)):
    user_picture: Union[models.Picture, None] = None
    model_picture: Union[models.ModelPicture, None] = None

    if user_picture_id and model_picture_id:
        user_picture = picture_actions.read_picture_by_id(db, picture_id=user_picture_id)
        model_picture = model_picture_actions.read_model_picture_by_id(db, model_picture_id=model_picture_id)

    elif user_picture_file_name and model_picture_file_name:
        picture_results: List[models.Picture] = picture_actions.read_picture_by_file_name(db=db,
                                                                                          file_name=user_picture_file_name,
                                                                                          limit=1)
        if len(picture_results):
            user_picture = picture_results[0]
            model_pictures_results = model_picture_actions.read_model_picture_by_file_name(db=db,
                                                                                           file_name=model_picture_file_name,
                                                                                           limit=1)
            if len(model_pictures_results):
                model_picture = model_pictures_results[0]

    else:
        raise HTTPException(status_code=400,
                            detail='Please enter (user_picture_id AND model_picture_id) OR (user_picture_filename AND '
                                   'model_picture_filename)')

    if user_picture and model_picture:
        # apply hair transfer
        picture_info = picture_service.change_hairstyle(user_picture=user_picture, model_picture=model_picture)
        print(picture_info)

        # create new picture and add to db
        new_picture = models.Picture(file_name=picture_info.file_name, file_path=picture_info.file_path,
                                     file_size=picture_info.file_size, height=picture_info.height,
                                     width=picture_info.width)

        mod_pic = picture_actions.add_picture(db=db, picture=new_picture)

        user = history_actions.get_user_id_from_picture_id(db=db, picture_id=user_picture.id)

        if user:
            model_picture: models.ModelPicture = model_picture_actions.read_model_picture_by_id(db=db,
                                                                                                model_picture_id=model_picture.id)
            if model_picture:
                new_history = models.History(picture_id=mod_pic.id, original_picture_id=user_picture.id,
                                             hair_style_id=model_picture.hair_style_id,
                                             user_id=user.id)

                history_entry = history_actions.add_history(db=db, history=new_history)
                mod_pic: models.Picture = picture_actions.read_picture_by_id(picture_id=user_picture.id, db=db)
                return {"picture": mod_pic, "history_entry": history_entry}
            raise HTTPException(status_code=404, detail='Model picture not found')
        raise HTTPException(status_code=404, detail='No user associated with this picture was found')

    raise HTTPException(status_code=404, detail='No user picture or model picture associated with these IDs were found')


@router.delete("/{picture_id}", status_code=status.HTTP_200_OK, response_model=List[schemas.Picture])
async def delete_picture(picture_id: int, response: Response, db: Session = Depends(get_db)):
    """
    DELETE /pictures/{picture_id}
    :param db: db session instance
    :param response: response object
    :param picture_id: ID of the picture record to be deleted from the database
    """
    print(" *************** DELETE PICTURE *************************")
    if not db.query(models.Picture).filter(models.Picture.id == picture_id).first():
        response.status_code = status.HTTP_404_NOT_FOUND

    # get the file_name of the selected picture to delete
    selected_picture = picture_actions.read_picture_by_id(db, picture_id)
    selected_file_name = selected_picture.file_name.split('.')[0]
    print(selected_file_name)

    # search for all pictures containing the selected_file_name
    selected_pictures = picture_actions.read_pictures(db, search=selected_file_name)

    for pic in selected_pictures:
        print(pic.file_path + pic.file_name)
        # delete from db
        picture_actions.delete_picture(db=db, picture_id=pic.id)
        # delete from disk
        picture_service.delete_picture(pic.file_path, pic.file_name)

    # return picture_actions.delete_picture(db=db, picture_id=picture_id)
    return selected_pictures
