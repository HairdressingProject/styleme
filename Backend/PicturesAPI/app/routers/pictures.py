import json
import os
from typing import List, Optional, Union

import requests
from fastapi import APIRouter, File, Depends, UploadFile, status, Request, Response, HTTPException
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session

from app import services, actions, models, schemas
from app.database.db import SessionLocal
from app.settings import PICTURE_UPLOAD_FOLDER, ADMIN_PORTAL_HOST, USERS_API_URL

router = APIRouter()
picture_service = services.PictureService()
picture_actions = actions.PictureActions()
history_actions = actions.HistoryActions()
user_actions = actions.UserActions()
hair_colour_actions = actions.HairColourActions()
hair_style_actions = actions.HairStyleActions()
model_picture_actions = actions.ModelPictureActions()
face_shape_actions = actions.FaceShapeActions()
face_shape_service = services.FaceShapeService()


def get_user_data_from_token(request: Request) -> Optional[schemas.AuthenticatedUser]:
    """
    Retrieve user information from token
    :param request:
    :return: User information in json object
    """
    if "authorization" not in request.headers.keys() and "auth" not in request.cookies.keys():
        print(f"No authorization header or auth cookie found")
        return None

    authorization_header = request.headers.get("authorization")
    auth_cookie = request.cookies.get("auth")

    users_api_req_headers = {
        "origin": f"https://{ADMIN_PORTAL_HOST}"
    }

    if authorization_header:
        users_api_req_headers["authorization"] = authorization_header

    if auth_cookie:
        users_api_req_headers["cookie"] = f"auth={auth_cookie}"

    users_api_response = requests.get(f"{USERS_API_URL}/users/authenticate", headers=users_api_req_headers)
    try:
        if users_api_response.ok:
            json_response = users_api_response.json()
            return json_response
    except json.decoder.JSONDecodeError:
        pass

    return None


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("", status_code=status.HTTP_201_CREATED)
async def upload_picture(request: Request, file: UploadFile = File(...), db: Session = Depends(get_db)):
    """
    Upload a user picture. IF picture is valid, the face shape is detected, a new record is added to the pictures and
    history table, and the picture file is saved
    :param request:
    :param file: Selected binary picture file to be uploaded
    :param db: db session instance
    :return: Json response that contains the picture information, the detected face shape and the history record
    """
    user_data = get_user_data_from_token(request)

    if user_data:
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

                face_shape_detected: models.FaceShape = face_shape_actions.get_face_shape(db=db,
                                                                                          face_shape_id=face_shape_id)

                user_id = user_data['id']

                new_history: schemas.HistoryCreate = schemas.HistoryCreate(
                    picture_id=orig_pic.id,
                    original_picture_id=orig_pic.id,
                    face_shape_id=face_shape_id,
                    user_id=user_id
                )

                new_history_entry: models.History = history_actions.add_history(db=db, history=new_history)

                results = picture_actions.read_picture_by_file_name(db=db, file_name=new_picture.file_name, limit=1)
                return {'picture': results[0], 'face_shape': face_shape[0], 'history_entry': new_history_entry}
        else:
            raise HTTPException(status_code=422, detail="No face detected")
    else:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")


@router.get("/file/{picture_id}", status_code=status.HTTP_200_OK)
async def read_picture_file(picture_id: int, db: Session = Depends(get_db)):
    """
    Get a picture File object identified by it's picture ID
    :param picture_id: ID of the picture
    :param db: db session instance
    :return: Binary File
    """
    selected_picture = picture_actions.read_picture_by_id(picture_id=picture_id, db=db)
    if selected_picture:
        file_path = selected_picture.file_path + selected_picture.file_name
        if os.path.exists(file_path):
            return FileResponse(file_path)
    raise HTTPException(status_code=404, detail='Picture file not found')


@router.get("/id/{picture_id}", response_model=schemas.Picture)
async def read_picture(picture_id: int, db: Session = Depends(get_db)):
    """Get a picture identified by it's id
    :param picture_id: ID of the picture
    :param db: db session instance
    :return: instance of Picture class that matches the ID
    """
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
    """ Read all pictures from db
    :param skip: optionally skip a number of records (default = 0)
    :param limit: optionally limit the number of results retrieved (default = 1000)
    :param search: optionally search history records by username (default = "") include a search string
    :param db: db session instance
    :return: List of pictures
    """
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

                # detect face_shape
                face_shape = picture_service.detect_face_shape(picture.file_name, picture.file_path)
                if face_shape is None:
                    return {"face shape detected"}
            try:
                return {'face_shape': face_shape[0]}
            except:
                raise HTTPException(status_code=422, detail="Could not compute face shape from picture")
        raise HTTPException(status_code=422, detail="Could not detect a face in the picture")
    raise HTTPException(status_code=404, detail="Could not find picture by id")


@router.get("/change_hair_colour/{picture_id}", status_code=status.HTTP_200_OK)
async def change_hair_colour(picture_id: int, colour: str, r: int, b: int, g: int, db: Session = Depends(get_db)):
    """Applies changes to hair colour based on a base colour name (e.g. hot pink) and RGB values, which vary by lightness

    :param picture_id: ID of the picture to be processed
    :param db: db session instance
    :param colour: Base hair colour name
    :param r: Red channel of the colour
    :param g: Green channel of the colour
    :param b: Blue channel of the colour
    :returns: New picture object and history entry reflecting changes
    """

    selected_picture: Union[models.Picture, None] = None

    if picture_id:
        selected_picture = picture_actions.read_picture_by_id(db, picture_id=picture_id)
    else:
        raise HTTPException(status_code=400, detail='Picture ID not found')

    if selected_picture:
        # apply hair colour
        try:
            picture_info = picture_service.change_hair_colour_RGB(file_name=selected_picture.file_name,
                                                                  r=r, b=b, g=g,
                                                                  file_path=selected_picture.file_path)
            # create new picture and add to db
            new_picture = models.Picture(file_name=picture_info.file_name, file_path=picture_info.file_path,
                                         file_size=picture_info.file_size, height=picture_info.height,
                                         width=picture_info.width)

            mod_pic = picture_actions.add_picture(db=db, picture=new_picture)

            # selected_picture = picture_actions.read_picture_by_id(db, picture_id=picture_id)
            # print(selected_picture.file_name)
            # print(selected_picture.file_path)

            # apply selected colour
            # picture_info = picture_service.change_hair_colour_RGB(file_name=selected_picture.file_name, selected_colour=colour,
            #                                                    r=r, g=g, b=b,
            #                                                    file_path=selected_picture.file_path)
            # print(picture_info)

            # create new picture and add to db
            # new_picture = models.Picture(file_name=picture_info.file_name, file_path=picture_info.file_path,
            #                              file_size=picture_info.file_size, height=picture_info.height, width=picture_info.width)

            # mod_pic = picture_actions.add_picture(db=db, picture=new_picture)

            # fake user_id
            user: models.User = history_actions.get_user_id_from_picture_id(db=db, picture_id=picture_id)

            if user:
                hair_colour_results: List[models.HairColour] = hair_colour_actions.get_hair_colours(db=db,
                                                                                                    search=colour,
                                                                                                    limit=1)
                if len(hair_colour_results):
                    hair_colour = hair_colour_results[0]
                    # get latest history entry to extract face_shape_id and hair_style_id
                    user_history: List[models.History] = history_actions.get_user_history(db=db, user_id=user.id)
                    latest_history_entry: models.History = user_history[-1]

                    new_history: schemas.HistoryCreate = schemas.HistoryCreate(
                        picture_id=mod_pic.id,
                        original_picture_id=latest_history_entry.original_picture_id,
                        previous_picture_id=selected_picture.id,
                        hair_colour_id=hair_colour.id,
                        face_shape_id=latest_history_entry.face_shape_id,
                        hair_style_id=latest_history_entry.hair_style_id,
                        user_id=user.id
                    )

                    history_entry: models.History = history_actions.add_history(db=db, history=new_history)

                    hair_colour_entry: models.HairColour = hair_colour_actions.get_hair_colour_by_id(db=db,
                                                                                                     hair_colour_id=hair_colour.id)

                    # get new picture with modified hair colour
                    new_pic: models.Picture = picture_actions.read_picture_by_id(db=db,
                                                                                 picture_id=history_entry.picture_id)

                    return {'history_entry': history_entry, 'picture': new_pic, 'hair_colour': hair_colour_entry}
                raise HTTPException(status_code=404,
                                    detail='No hair colour record associated with this colour name was found')
        except Exception as ex:
            print(ex)
            raise HTTPException(status_code=422,
                                detail='Could not change hair colour. Please try a different picture. Exception: ' + ex)
        raise HTTPException(status_code=404, detail='Selected picture not found')
    raise HTTPException(status_code=404, detail='No user associated with this picture ID was found')


@router.get("/change_hair_style", status_code=status.HTTP_200_OK)
async def change_hairstyle(user_picture_id: Optional[int] = None, model_picture_id: Optional[int] = None,
                           user_picture_file_name: Optional[str] = None, model_picture_file_name: Optional[str] = None,
                           db: Session = Depends(get_db)):
    """
    Change user's picture hairstyle based on the selected model picture hairstyle, add record to pictures table and
    history table

    :param user_picture_id: The ID of the user picture to be modified
    :param model_picture_id: the ID of the model picture hairstyle
    :param user_picture_file_name: the user picture filename
    :param model_picture_file_name: the model picture filename
    :param db: db session instance
    :return: history record
    """
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

        try:
            # get original picture from history based on user_picture
            pic_history: List[models.History] = history_actions.get_picture_history(db=db,
                                                                                    filename=user_picture.file_name)
            original_pic_id: int = pic_history[0].original_picture_id
            original_pic: models.Picture = picture_actions.read_picture_by_id(db=db, picture_id=original_pic_id)

            # apply hair transfer
            picture_info = picture_service.change_hairstyle(user_picture=original_pic, model_picture=model_picture)
            print(picture_info)

            # create new picture and add to db
            new_picture: schemas.PictureCreate = schemas.PictureCreate(
                file_name=picture_info.file_name,
                file_path=picture_info.file_path,
                file_size=picture_info.file_size,
                height=picture_info.height,
                width=picture_info.width
            )

            mod_pic = picture_actions.add_picture(db=db, picture=new_picture)

            user = history_actions.get_user_id_from_picture_id(db=db, picture_id=user_picture.id)

            if user:
                # get latest user history entry to add face_shape_id
                history: List[models.History] = history_actions.get_user_history(db=db, user_id=user.id)

                if len(history):
                    latest_entry = history[-1]
                    model_picture: models.ModelPicture = model_picture_actions.read_model_picture_by_id(db=db,
                                                                                                        model_picture_id=model_picture.id)
                    if model_picture:
                        new_history: schemas.HistoryCreate = schemas.HistoryCreate(picture_id=mod_pic.id,
                                                                                   original_picture_id=latest_entry.original_picture_id,
                                                                                   previous_picture_id=latest_entry.picture_id,
                                                                                   #    hair_colour_id=latest_entry.hair_colour_id,
                                                                                   hair_style_id=model_picture.hair_style_id,
                                                                                   face_shape_id=latest_entry.face_shape_id,
                                                                                   user_id=user.id)

                        history_entry = history_actions.add_history(db=db, history=new_history)
                        new_hair_style = hair_style_actions.get_hair_style(db=db,
                                                                           hair_style_id=history_entry.hair_style_id)

                        current_picture = picture_actions.read_picture_by_id(db=db, picture_id=history_entry.picture_id)
                        original_picture = picture_actions.read_picture_by_id(db=db,
                                                                              picture_id=history_entry.original_picture_id)

                        return {
                            "history_entry": history_entry,
                            "hair_style": new_hair_style,
                            "current_picture": current_picture,
                            "original_picture": original_picture
                        }
                    raise HTTPException(status_code=404, detail='Model picture not found')
                raise HTTPException(status_code=404,
                                    detail='No history associated with this user was found. Please upload a picture '
                                           'first.')
            raise HTTPException(status_code=404, detail='No user associated with this picture was found')
        except Exception as e:
            raise HTTPException(status_code=422,
                                detail=f'Could not apply hair style swap. Please try another image. Exception: {e}')

    raise HTTPException(status_code=404, detail='No user picture or model picture associated with these IDs were found')


@router.get("/users/{user_id}/latest", status_code=status.HTTP_200_OK)
async def get_latest_user_picture_file(user_id: int, db: Session = Depends(get_db)):
    """
    GET /pictures/users/{user_id}/latest

    Retrieves the latest picture file uploaded by the user identified by `user_id`

    :param user_id: User ID associated with the picture to be retrieved
    :param db: db session instance
    :returns: Picture file found
    :raise HTTPException: 404 if the picture is not found
    """
    # check whether user exists first
    user = user_actions.get_user(user_id=user_id, db=db)

    if user:
        latest_history_entry = history_actions.get_latest_user_history_entry(db=db, user_id=user_id)

        if latest_history_entry:
            # get picture file
            pic = picture_actions.read_picture_by_id(db=db, picture_id=latest_history_entry.picture_id)

            if pic:
                file_path = pic.file_path + pic.file_name
                if os.path.exists(file_path):
                    return FileResponse(file_path)
                raise HTTPException(status_code=404, detail='Picture file not found')
            raise HTTPException(status_code=404, detail='Picture entry not found in the database')
        raise HTTPException(status_code=404, detail='No history entry associated with this user was found')
    raise HTTPException(status_code=404, detail='User not found')


@router.delete("/{picture_id}", status_code=status.HTTP_200_OK, response_model=List[schemas.Picture])
async def delete_picture(picture_id: int, response: Response, db: Session = Depends(get_db)):
    """
    DELETE /pictures/{picture_id}
    :param db: db session instance
    :param response: response object
    :param picture_id: ID of the picture record to be deleted from the database
    """
    selected_picture = picture_actions.read_picture_by_id(db, picture_id)

    if not selected_picture:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Picture to be deleted was not found')

    # get the file_name of the selected picture to delete
    selected_file_name = selected_picture.file_name.split('.')[0]

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


@router.delete("/discard_changes/{original_picture_id}", status_code=status.HTTP_200_OK)
async def discard_changes(original_picture_id: int, db: Session = Depends(get_db)):
    picture_history = history_actions.get_picture_history_by_id(db=db, original_picture_id=original_picture_id)

    if len(picture_history):
        # select all entries except the very first one (where original picture id == picture id)
        to_be_deleted = filter(lambda h: h.picture_id != h.original_picture_id, picture_history)

        for entry in to_be_deleted:
            picture_actions.delete_picture(db=db, picture_id=entry.picture_id)
            history_actions.delete_history(db=db, history_id=entry.id)

        # return first history entry along with picture
        entries = history_actions.get_picture_history_by_id(db=db, original_picture_id=original_picture_id)

        if len(entries):
            first_entry = entries[0]
            current_picture = picture_actions.read_picture_by_id(db=db, picture_id=first_entry.original_picture_id)

            return {
                "history": first_entry,
                "current_picture": current_picture
            }

        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail='Sorry, all history entries associated with this picture were deleted')

    raise HTTPException(status_code=status.HTTP_204_NO_CONTENT)
