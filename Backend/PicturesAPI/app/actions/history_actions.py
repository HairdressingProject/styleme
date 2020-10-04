from typing import List, Union

from fastapi import Response, status
from sqlalchemy import desc
from sqlalchemy.orm import Session

from app import models, schemas


class HistoryActions:
    def get_history(self, db: Session, history_id: int) -> models.History:
        """
        Retrieves a history record from the database
        :param db: db session instance
        :param history_id: ID of the history record to be retrieved
        :return: History instance
        """
        return db.query(models.History).filter(models.History.id == history_id).first()

    def get_entire_history(self, db: Session, skip: int = 0, limit: int = 1000, search: str = "") -> List[
        models.History]:
        """
        Retrieves all history records from the database
        :param db: db session instance
        :param skip: optionally skip a number of records (default = 0)
        :param limit: optionally limit the number of results retrieved (default = 1000)
        :param search: optionally search history records by username (default = "")
        :return: History records of the user
        """
        if search:
            search_results = db.query(models.History).join(models.User,
                                                           models.User.id == models.History.user_id).filter(
                models.User.user_name.ilike("%" + search.strip() + "%")).offset(skip).limit(
                limit).all()
            return search_results

        return db.query(models.History).offset(skip).limit(limit).all()

    def get_user_history(self, db: Session, user_id: int) -> List[models.History]:
        """
        Retrieves all history records associated with a user
        :param db: db session instance
        :param user_id: ID of the user to retrieve history records
        :return: History records of the user
        """
        return db.query(models.History).filter(models.History.user_id == user_id).all()

    def get_picture_history(self, db: Session, filename: str) -> List[models.History]:
        """
        Retrieves all history records associated with a picture identified by its filename
        :param db: db session instance
        :param filename: file name of the picture
        :return: history records containing picture_id that correspond to the picture identified by its filename
        """
        return db.query(models.History).join(models.Picture,
                                             models.History.picture_id == models.Picture.id) \
            .filter(
            models.Picture.file_name.ilike("%" + filename.strip() + "%")).first()

    def add_history(self, db: Session, history: schemas.HistoryCreate) -> models.History:
        """
        Adds history entry to db
        :param db: db session instance
        :param history: new history record to be added
        :return: History instance
        """
        db_history = models.History(picture_id=history.picture_id, original_picture_id=history.original_picture_id,
                                    hair_colour_id=history.hair_colour_id,
                                    hair_style_id=history.hair_style_id, face_shape_id=history.face_shape_id,
                                    user_id=history.user_id)
        db.add(db_history)
        db.commit()
        db.refresh(db_history)
        return db_history

    def update_history(self, db: Session, history_id: int, history: schemas.HistoryUpdate) -> models.History:
        """
        Updates a history record in the database
        :param db: db session instance
        :param history_id: ID of the history entry to be updated
        :param history: new history record to be added
        :return: History instance
        """
        history_entry: models.History = db.query(models.History).filter(models.History.id == history_id).first()

        if history_entry is not None:
            history_entry.picture_id = history.picture_id
            history_entry.original_picture_id = history.original_picture_id
            history_entry.previous_picture_id = history.previous_picture_id
            history_entry.face_shape_id = history.face_shape_id
            history_entry.hair_colour_id = history.hair_colour_id
            history_entry.hair_style_id = history.hair_style_id
            history_entry.user_id = history.user_id

            db.add(history_entry)
            db.commit()
            db.refresh(history_entry)

        return history_entry

    def add_face_shape(self, db: Session,
                       history_record_with_new_face_shape: schemas.HistoryAddFaceShape) -> Union[models.History, None]:
        """
        Similar to add_history, this method adds a new history record to the database based on the latest one,
        with a new face_shape_id
        :param db: db session instance
        :param history_record_with_new_face_shape: history
        record with user_id and face_shape_id to be added
        :return: new history record with updated face_shape_id or
        None if there are no history entries associated with this user
        """
        latest_history_entry: models.History = db.query(models.History).filter(
            models.History.user_id == history_record_with_new_face_shape.user_id).order_by(
            desc(models.History.id)).first()

        if latest_history_entry is not None:
            new_history_entry = models.History(picture_id=latest_history_entry.picture_id,
                                               original_picture_id=latest_history_entry.original_picture_id,
                                               hair_colour_id=latest_history_entry.hair_colour_id,
                                               hair_style_id=latest_history_entry.hair_style_id,
                                               face_shape_id=history_record_with_new_face_shape.face_shape_id,
                                               user_id=latest_history_entry.user_id)
            db.add(new_history_entry)
            db.commit()
            db.refresh(new_history_entry)
            return new_history_entry
        return None

    def delete_history(self, db: Session, history_id: int) -> models.History:
        """
        Deletes a history record from the database
        :param db: db session instance
        :param history_id: ID of the history entry to be updated
        :return: History instance
        """
        history_entry: models.History = db.query(models.History).filter(models.History.id == history_id).first()

        if history_entry is not None:
            db.delete(history_entry)
            db.commit()

        return history_entry

    def validate_history_entry(self, db: Session, history: Union[schemas.HistoryCreate, schemas.HistoryUpdate]) -> (
            bool, str):
        """
        Validates HistoryCreate instances, checking for existing entries in the database
        :param db: db session instance
        :param history: HistoryCreate instance to be validated
        :return: Validation result in the format (result, message)
        """
        found_picture = db.query(models.Picture).filter(models.Picture.id == history.picture_id).first()

        if not found_picture:
            return False, "Invalid picture_id"

        if history.original_picture_id is not None:
            if history.original_picture_id > 0:
                found_original = db.query(models.Picture).filter(
                    models.Picture.id == history.original_picture_id).first()
                if not found_original:
                    return False, "Invalid original_picture_id"
            else:
                return False, "Invalid original_picture_id"

        if history.previous_picture_id is not None:
            if history.previous_picture_id > 0:
                found_previous = db.query(models.Picture).filter(
                    models.Picture.id == history.previous_picture_id).first()
                if not found_previous:
                    return False, "Invalid previous_picture_id"
            else:
                return False, "Invalid previous_picture_id"

        if history.hair_colour_id is not None:
            if history.hair_colour_id > 0:
                found_colour = db.query(models.HairColour).filter(
                    models.HairColour.id == history.hair_colour_id).first()
                if not found_colour:
                    return False, "Invalid hair_colour_id"
            else:
                return False, "Invalid hair_colour_id"

        if history.hair_style_id is not None:
            if history.hair_style_id > 0:
                found_hair_style = db.query(models.HairStyle).filter(
                    models.HairStyle.id == history.hair_style_id).first()
                if not found_hair_style:
                    return False, "Invalid hair_style_id"
            else:
                return False, "Invalid hair_style_id"

        if history.face_shape_id is not None:
            if history.face_shape_id > 0:
                found_face_shape = db.query(models.FaceShape).filter(
                    models.FaceShape.id == history.face_shape_id).first()
                if not found_face_shape:
                    return False, "Invalid face_shape_id"
            else:
                return False, "Invalid face_shape_id"

        if history.user_id is not None:
            if history.user_id > 0:
                found_user_id = db.query(models.User).filter(models.User.id == history.user_id).first()
                if not found_user_id:
                    return False, "Invalid user_id"
            else:
                return False, "Invalid user_id"

        return True, ""
