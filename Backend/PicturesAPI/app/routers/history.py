"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 02/10/2020 7:47 pm
File: history.py
"""

from fastapi import APIRouter, Depends, status, Response
from sqlalchemy.orm import Session

from app import actions, models, schemas
from app.database.db import SessionLocal

router = APIRouter()
history_actions = actions.HistoryActions()


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
async def get_user_history(user_id: int, response: Response, db: Session = Depends(get_db)):
    """
    GET /history/users/{user_id}
    :param db: db session instance
    :param response: response object
    :param user_id: ID of the user to retrieve their history records
    """

    if not db.query(models.User).filter(models.User.id == user_id).first():
        response.status_code = status.HTTP_404_NOT_FOUND

    return history_actions.get_user_history(db=db, user_id=user_id)


@router.get("/", status_code=status.HTTP_200_OK)
async def get_entire_history(skip: int = 0, limit: int = 1000, search: str = "", db: Session = Depends(get_db)):
    """
    GET /history[?skip=0&limit=1000&search=""]
    :param db: db session instance
    :param skip: optionally skip a number of records (default = 0)
    :param limit: optionally limit the number of results retrieved (default = 1000)
    :param search: optionally search history records by username (default = "")
    """
    return history_actions.get_entire_history(db=db, skip=skip, limit=limit, search=search)


@router.post("/", status_code=status.HTTP_201_CREATED)
async def add_history(history: schemas.HistoryCreate, db: Session = Depends(get_db)):
    """
    POST /history
    :param db: db session instance
    :param history: HistoryCreateUpdate instance to be added to the database
    """
    return history_actions.add_history(db=db, history=history)


@router.post("/add_face_shape", status_code=status.HTTP_201_CREATED)
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
        response.status_code = status.HTTP_404_NOT_FOUND
        return {
            "message": "Face shape or user entry not found"
        }

    new_history_record = history_actions.add_face_shape(db=db,
                                                        history_record_with_new_face_shape=history_record_with_new_face_shape)

    if new_history_record is None:
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {
            "message": "There is no previous history record associated with this user. Please upload a picture first "
                       "and then update your face shape."
        }

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
    if not db.query(models.History).filter(models.History.id == history_id).first():
        response.status_code = status.HTTP_404_NOT_FOUND

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