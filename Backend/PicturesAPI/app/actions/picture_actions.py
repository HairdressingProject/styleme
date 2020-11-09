from typing import List, Union

from sqlalchemy.orm import Session

from app import models
from app.models.picture import Picture
from app.schemas.picture import PictureCreate


class PictureActions:
    """
    CRUD operations related to Picture class
    """
    def add_picture(self, db: Session, picture: PictureCreate):
        """
        Add a picture record to database
        :param db: db session instance
        :param picture: PictureCreate schema
        :return: Picture class instance of the created record
        """
        db_picture = Picture(file_name=picture.file_name, file_path=picture.file_path, file_size=picture.file_size,
                             height=picture.height, width=picture.width)
        db.add(db_picture)
        db.commit()
        db.refresh(db_picture)
        return db_picture

    def read_picture_by_id(self, db: Session, picture_id) -> Union[Picture, None]:
        """
        Read a picture record identified by it's ID from the database
        :param db: db session instance
        :param picture_id: ID of the selected picture
        :return: Picture class instance that match the selected ID
        """
        return db.query(Picture).filter(Picture.id == picture_id).first()

    def read_picture_by_file_name(self, db: Session, file_name: str, skip: int = 0, limit: int = 100) -> List[Picture]:
        """
        Read a picture record identified by it's filename from database
        :param db: db session instance
        :param file_name: string or substring of filename
        :param skip: optionally skip a number of records (default = 0)
        :param limit: optionally limit the number of results retrieved (default = 1000)
        :return: List of picture class instances that matches the file_name query string
        """
        return db.query(Picture).filter(Picture.file_name.ilike("%" + file_name.strip() + "%")).offset(skip).limit(
            limit).all()

    def read_pictures(self, db: Session, skip: int = 0, limit: int = 100, search: str = ""):
        """
        Read all picture records from database
        :param db: db session instance
        :param skip: optionally skip a number of records (default = 0)
        :param limit: optionally limit the number of results retrieved (default = 1000)
        :param search: optionally search history records by username (default = "")
        :return: List of picture class instances
        """
        if not search.strip():
            return db.query(Picture).offset(skip).limit(limit).all()
        return self.read_picture_by_file_name(db=db, file_name=search, skip=skip, limit=limit)

    def read_models(self, db: Session, skip: int = 0, limit: int = 100) -> List[models.Picture]:
        """
        Read all model pictures from database
        :param db: db session instance
        :param skip: optionally skip a number of records (default = 0)
        :param limit: optionally limit the number of results retrieved (default = 1000)
        :return: List of picture instance class of model pictures
        """
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
