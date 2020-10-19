from typing import List, Union

from sqlalchemy.orm import Session

from app import models, schemas
from app.models.model_picture import ModelPicture
from app.schemas.model_picture import ModelPictureCreate, ModelPictureUpdate


class FaceShapeActions:
    def get_face_shape(self, db: Session, id: int) -> Union[models.FaceShape, None]:
        return db.query(models.FaceShape).filter(models.FaceShape.id == id).first()
