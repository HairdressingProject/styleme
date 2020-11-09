from typing import List

from sqlalchemy.orm import Session

from app import models, schemas
from app.models.model_picture import ModelPicture
from app.schemas.model_picture import ModelPictureCreate, ModelPictureUpdate


class ModelPictureActions:
    """
    CRUD operations related to ModelPicture class
    """
    def add_model_picture(self, db: Session, picture: ModelPictureCreate):
        """
        Add a model picture record to database
        :param db: db session instance
        :param picture: ModelPictureCreate schema
        :return: ModelPicture class instance of the created record
        """
        db_picture = ModelPicture(file_name=picture.file_name, file_path=picture.file_path,
                                  file_size=picture.file_size, height=picture.height, width=picture.width,
                                  face_shape_id=picture.face_shape_id)
        db.add(db_picture)
        db.commit()
        db.refresh(db_picture)
        return db_picture

    def read_model_picture_by_file_name(self, db: Session, file_name: str, skip: int = 0, limit: int = 100) -> List[
        ModelPicture]:
        """
        Read a model picture record identified by it's ID from the database
        :param db: db session instance
        :param file_name: file name string
        :param skip: optionally skip a number of records (default = 0)
        :param limit: optionally limit the number of results retrieved (default = 1000)
        :return: List of ModelPicture class instances
        """
        return db.query(ModelPicture) \
            .filter(ModelPicture.file_name.ilike("%" + file_name.strip() + "%")) \
            .offset(skip).limit(limit).all()

    def read_model_picture_by_id(self, db: Session, model_picture_id: int):
        """
        Read a model picture record identified by it's ID from the database
        :param db: db session instance
        :param model_picture_id: ID of the selected model picture
        :return: ModelPicture class instance that match the selected ID
        """
        return db.query(ModelPicture).filter(ModelPicture.id == model_picture_id).first()

    def read_model_pictures(self, db: Session, skip: int = 0, limit: int = 100, search: str = ""):
        """
        Read all model picture records from database
        :param db: db session instance
        :param skip: optionally skip a number of records (default = 0)
        :param limit: optionally limit the number of results retrieved (default = 1000)
        :param search: optionally search history records by username (default = "")
        :return: List of ModelPicture class instances
        """
        if not search.strip():
            return db.query(ModelPicture).offset(skip).limit(limit).all()
        return self.read_model_picture_by_file_name(db=db, file_name=search, skip=skip, limit=limit)

    def delete_model_picture(self, db: Session, model_picture_id: int) -> models.ModelPicture:
        """
        Deletes a model picture record from the database
        :param db: db session instance
        :param model_picture_id: ID of the history entry to be updated
        :return: Model picture
        """
        picture_entry: models.ModelPicture = db.query(models.ModelPicture).filter(
            models.ModelPicture.id == model_picture_id).first()

        if picture_entry is not None:
            db.delete(picture_entry)
            db.commit()

        return picture_entry

    def update_model_picture(self, db: Session, model_picture_id: int, model_picture: schemas.ModelPictureUpdate) -> models.ModelPicture:
        """
        Updates a model picture record in the database
        :param db: db session instance
        :param model_picture_id: ID of the model picture entry to be updated
        :param model_picture: new model picture record to be updated
        :return: ModelPicture instance
        """

        model_picture_entry: models.ModelPicture = db.query(models.ModelPicture).filter(models.ModelPicture.id == model_picture_id).first()

        if model_picture_entry is not None:
            # model_picture_entry.file_name = model_picture.file_name
            # model_picture_entry.file_path = model_picture.file_path
            # model_picture_entry.file_size = model_picture.file_size
            # model_picture_entry.height = model_picture.height
            # model_picture_entry.width = model_picture.width
            model_picture_entry.face_shape_id = model_picture.face_shape_id
            model_picture_entry.hair_length_id = model_picture.hair_length_id
            model_picture_entry.hair_style_id = model_picture.hair_style_id
            model_picture_entry.hair_colour_id = model_picture.hair_colour_id

            db.add(model_picture_entry)
            db.commit()
            db.refresh(model_picture_entry)

        return model_picture_entry
