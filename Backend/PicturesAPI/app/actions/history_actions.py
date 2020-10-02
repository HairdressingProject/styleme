from sqlalchemy.orm import Session
from app.models import History
from app.schemas import HistoryCreateUpdate


class HistoryActions:
    def add_history(self, db: Session, history: HistoryCreateUpdate):
        """
        Adds history to db
        :param history: new history record to be added
        :return: History instance
        """
        db_history = History(picture_id=history.picture_id, original_picture_id=history.original_picture_id, hair_colour_id=history.hair_colour_id,
                             hair_style_id=history.hair_style_id, face_shape_id=history.face_shape_id,
                             user_id=history.user_id)
        db.add(db_history)
        db.commit()
        db.refresh(db_history)
        return db_history

    def read_history_by_id(self, db: Session, original_picture_id):
        return db.query(History).filter(History.original_picture_id == original_picture_id).first()

    def change_hair_colour(self, db: Session, picture_id, colour_id):
        return db.query(History).update().where(original_picture_id=picture_id).values(hair_colour_id=colour_id)