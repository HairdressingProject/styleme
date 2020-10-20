from typing import List, Union, Optional

from sqlalchemy.orm import Session

from app import models, schemas
from app.models.model_picture import ModelPicture
from app.schemas.model_picture import ModelPictureCreate, ModelPictureUpdate


class FaceShapeActions:
    def get_face_shapes(self, db: Session, skip: Optional[int] = 0, limit: Optional[int] = 100,
                        search: Optional[str] = "") -> List[models.FaceShape]:
        if not search.strip():
            return db.query(models.FaceShape).offset(skip).limit(limit).all()
        return db.query(models.FaceShape).filter(models.FaceShape.shape_name.ilike('%' + search + '%')).offset(
            skip).limit(limit).all()

    def get_face_shape(self, db: Session, face_shape_id: int) -> Union[models.FaceShape, None]:
        return db.query(models.FaceShape).filter(models.FaceShape.id == face_shape_id).first()
