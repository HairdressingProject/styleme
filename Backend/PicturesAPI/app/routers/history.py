"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 02/10/2020 7:47 pm
File: history.py
"""

from fastapi import APIRouter, Depends, status, Response, HTTPException
from sqlalchemy.orm import Session

from app import actions, models, schemas
from app.database.db import SessionLocal

router = APIRouter()
history_actions = actions.HistoryActions()
picture_actions = actions.PictureActions()
user_actions = actions.UserActions()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/{history_id}", status_code=status.HTTP_200_OK)
async def get_history(history_id: int, response: Response, db: Session = Depends(get_db)):
    """
    GET /history/{history_id}

    :param history_id: ID of the history record to be retrieved
    :param response: response object
    :param db: db session instance
    """
    result = history_actions.get_history(db=db, history_id=history_id)

    if not result:
        response.status_code = status.HTTP_404_NOT_FOUND
    return result


@router.get("/users/{user_id}", status_code=status.HTTP_200_OK)
async def get_user_history(user_id: int, db: Session = Depends(get_db)):
    """
    GET /history/users/{user_id}

    :param db: db session instance
    :param user_id: ID of the user to retrieve their history records
    """

    if not db.query(models.User).filter(models.User.id == user_id).first():
        raise HTTPException(status_code=404, detail='No user associated with this ID was found')

    return history_actions.get_user_history(db=db, user_id=user_id)


@router.get("/users/{user_id}/latest", status_code=status.HTTP_200_OK)
async def get_latest_user_history_entry(user_id: int, db: Session = Depends(get_db)):
    """
    GET /history/users/{user_id}/latest

    Retrieves the latest history entry associated with the user identified by `user_id`

    :param db: db session instance
    :param user_id: User ID whose latest history entry is to be retrieved
    :returns: Latest history entry associated with this user
    :raise HTTPException: 404 if user or latest history entry are not found
    """
    if user_actions.get_user(user_id=user_id, db=db):
        latest_entry = history_actions.get_latest_user_history_entry(db=db, user_id=user_id)
        if latest_entry:
            return latest_entry
        raise HTTPException(status_code=404, detail='History entry not found')
    raise HTTPException(status_code=404, detail='User not found')


@router.get("/pictures/{filename}", status_code=status.HTTP_200_OK)
async def get_picture_history(filename: str, response: Response, db: Session = Depends(get_db)):
    """
    GET /history/pictures/{filename}

    Gets all history records associated with a picture identified by its filename

    The filename can be linked to the original picture, previous one or current one

    :param filename: Picture filename
    :param response: response object
    :param db: db session instance
    """
    if not filename.strip():
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {
            "message": "Please provide a valid filename for the picture"
        }

    found_picture = db.query(models.Picture).filter(
        models.Picture.file_name.ilike("%" + filename.strip() + "%")).first()

    if not found_picture:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {
            "message": "Picture not found"
        }

    return history_actions.get_picture_history(db=db, filename=filename)


@router.get("", status_code=status.HTTP_200_OK)
async def get_entire_history(skip: int = 0, limit: int = 1000, search: str = "", db: Session = Depends(get_db)):
    """
    GET /history[?skip=0&limit=1000&search=""]

    :param db: db session instance
    :param skip: optionally skip a number of records (default = 0)
    :param limit: optionally limit the number of results retrieved (default = 1000)
    :param search: optionally search history records by username (default = "")
    """
    return history_actions.get_entire_history(db=db, skip=skip, limit=limit, search=search)


@router.post("", status_code=status.HTTP_201_CREATED)
async def add_history(history: schemas.HistoryCreate, response: Response, db: Session = Depends(get_db)):
    """
    POST /history

    :param db: db session instance
    :param response: response object
    :param history: HistoryCreate instance to be added to the database
    """
    validation_result = history_actions.validate_history_entry(db=db, history=history)
    if not validation_result[0]:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {
            "message": validation_result[1]
        }

    return history_actions.add_history(db=db, history=history)


@router.post("/face_shape", status_code=status.HTTP_201_CREATED)
async def add_face_shape(history_record_with_new_face_shape: schemas.HistoryAddFaceShape,
                         response: Response,
                         db: Session = Depends(get_db)):
    """
    POST /history/add_face_shape

    This route is similar to POST /history, except that it only takes face_shape_id into consideration.

    The new history record will be based on the latest one, with the new face shape added to face_shape_id

    :param db: db session instance
    :param response: response object
    :param history_record_with_new_face_shape: A history record that only contains face_shape_id
    """
    face_shape_entry = db.query(models.FaceShape).filter(
        models.FaceShape.id == history_record_with_new_face_shape.face_shape_id).first()

    user_entry = db.query(models.User).filter(models.User.id == history_record_with_new_face_shape.user_id).first()

    if face_shape_entry is None or user_entry is None:
        raise HTTPException(status_code=404, detail='Face shape or user entry not found')

    new_history_record = history_actions.add_face_shape(db=db,
                                                        history_record_with_new_face_shape=history_record_with_new_face_shape)

    if new_history_record is None:
        raise HTTPException(status_code=400,
                            detail='There is no previous history record associated with this user. Please upload a '
                                   'picture first'
                                   ' and then update your face shape.')

    return new_history_record


@router.put("/{history_id}", status_code=status.HTTP_200_OK)
async def update_history(history_id: int, history: schemas.HistoryUpdate, response: Response,
                         db: Session = Depends(get_db)):
    """
    PUT /history/{history_id}

    :param db: db session instance
    :param history: HistoryCreateUpdate instance to be updated in the database
    :param response: response object
    :param history_id: ID of the history record to be updated
    """
    if history_id != history.id:
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {
            "message": "History ID in the endpoint does not match the one sent in the request body"
        }

    if not db.query(models.History).filter(models.History.id == history_id).first():
        response.status_code = status.HTTP_404_NOT_FOUND
        return {
            "message": "History entry not found"
        }

    validation_result = history_actions.validate_history_entry(db=db, history=history)
    if not validation_result[0]:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {
            "message": validation_result[1]
        }

    return history_actions.update_history(db=db, history_id=history_id, history=history)


@router.delete("/{history_id}", status_code=status.HTTP_200_OK)
async def delete_history(history_id: int, response: Response, db: Session = Depends(get_db)):
    """
    DELETE /history/{history_id}

    :param db: db session instance
    :param response: response object
    :param history_id: ID of the history record to be deleted from the database
    """
    if not db.query(models.History).filter(models.History.id == history_id).first():
        response.status_code = status.HTTP_404_NOT_FOUND

    return history_actions.delete_history(db=db, history_id=history_id)
