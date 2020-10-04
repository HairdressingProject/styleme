from typing import List

from sqlalchemy.orm import Session

from app import models
from app.models.picture import Picture
from app.schemas.picture import PictureCreateUpdate


class PictureActions:
    def add_picture(self, db: Session, picture: PictureCreateUpdate):
        db_picture = Picture(file_name=picture.file_name, file_path=picture.file_path, file_size=picture.file_size,
                             height=picture.height, width=picture.width)
        db.add(db_picture)
        db.commit()
        db.refresh(db_picture)
        return db_picture

    def read_picture_by_id(self, db: Session, picture_id):
        return db.query(Picture).filter(Picture.id == picture_id).first()

    def read_picture_by_file_name(self, db: Session, file_name: str, skip: int = 0, limit: int = 100) -> List[Picture]:
        return db.query(Picture).filter(Picture.file_name.ilike("%" + file_name.strip() + "%")).offset(skip).limit(
            limit).all()

    def read_pictures(self, db: Session, skip: int = 0, limit: int = 100, search: str = ""):
        if not search.strip():
            return db.query(Picture).offset(skip).limit(limit).all()
        return self.read_picture_by_file_name(db=db, file_name=search, skip=skip, limit=limit)

    def read_models(self, db: Session, skip: int = 0, limit: int = 100) -> List[models.Picture]:
        search_results = db.query(models.Picture).filter(models.Picture.file_path.ilike("%pictures/models%")).offset(
            skip).limit(
            limit).all()
        return search_results

    def delete_picture(self, db: Session, picture_id: int) -> models.Picture:
        """
        Deletes a picture record from the database
        :param db: db session instance
        :param picture_id: ID of the history entry to be updated
        :return: History instance
        """
        picture_entry: models.Picture = db.query(models.Picture).filter(models.Picture.id == picture_id).first()

        if picture_entry is not None:
            db.delete(picture_entry)
            db.commit()

        return picture_entry
