from sqlalchemy.orm import Session
from app.models.picture import Picture
from app.schemas.picture import PictureCreate

class PictureActions:
    def add_picture(self, db: Session, picture: PictureCreate):
        db_picture = Picture(file_name=picture.file_name, file_path=picture.file_path, file_size=picture.file_size, height=picture.height, width=picture.width)
        db.add(db_picture)
        db.commit()
        db.refresh(db_picture)
        return db_picture

    def read_picture_by_id(self, db: Session, picture_id):
        return db.query(Picture).filter(Picture.id == picture_id).first()

    def read_pictures(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(Picture).offset(skip).limit(limit).all()
