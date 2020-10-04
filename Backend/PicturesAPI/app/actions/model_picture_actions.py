from sqlalchemy.orm import Session
from app.models.model_picture import ModelPicture
from app.schemas.model_picture import ModelPictureCreateUpdate


class ModelPictureActions:
    def add_model_picture(self, db: Session, picture: ModelPictureCreateUpdate):
        db_picture = ModelPicture(file_name=picture.file_name, file_path=picture.file_path,
                                  file_size=picture.file_size, height=picture.height, width=picture.width,
                                  face_shape_id=picture.face_shape_id, hair_style_id=picture.hair_style_id,
                                  hair_length_id=picture.hair_length_id, hair_colour_id=picture.hair_colour_id)
        db.add(db_picture)
        db.commit()
        db.refresh(db_picture)
        return db_picture

    def read_model_picture_by_id(self, db: Session, picture_id):
        return db.query(ModelPicture).filter(ModelPicture.id == picture_id).first()

    def read_model_pictures(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(ModelPicture).offset(skip).limit(limit).all()