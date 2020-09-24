# StyleMe - Pictures-API - Design
REST API boilerplate for the hairdressing project

## Design

### Classes
```mermaid
classDiagram
      Picture <|-- ModelPicture

    class Picture{
          -int id
          -string file_name
          -string file_path
          -string file_extension
          -string file_size
          -string file_name
          -string[] image_dimensions
          -date date_created
          -date date_updated
          -date date_deleted
          +get_id()
          +get_filename()
          +get_file_path()
          +get_file_extension()
          +get_resolution()
          +set_resolution(resolution)
          +get_size()
          +set_size(size)
          +get_date_created()
          +get_date_updated()
          +set_date_updated(date_updated)
          +get_date_deleted()
          +set_date_deleted(date_deleted)
      }
      
      class ModelPicture{
          -int hairstyle_id
          -int hair_legth_id
          -int face_shape_id
          -int hair_colour_id
          +get_hair_style()
          +set_hair_style_id(id)
          +get_hair_length()
          +set_hair_length_id(id)
          +get_face_shape()
          +set_face_shape_id(id)
          +get_hair_colour()
          +set_hair_colour_id(id)
          
      }
      
      class History{
          -int id
          -int picture_id
          -int original_picture_id
          -int hair_colour_id
          -int hair_style_id
          -int face_shape_id
          -int id user_id
          -date date_created
          -date date_updated
          -date date_deleted
          +get_id()
          +get_picture_id()
          +get_original_picture_id()
          +set_original_picture_id(id)
          +get_hair_colour()
          +get_hair_style()
          +get_face_shape()
          +get_user()
          +get_date_created()
          +get_date_updated()
          +set_date_updated(date_updated)
          +get_date_deleted()
          +set_date_deleted(date_deleted)
          
      }
      


```

```mermaid
classDiagram
      class PictureService{
          +save_picture(Picture, path, User)
          +detect_face_shape(Picture, User)
          +change_hair_style(Picture, HairStyle, User)
          +change_hair_colour(Picture, Colour, User)
          +change_face_shape(Picture, FaceShape, User)
      }
      
```


```mermaid
classDiagram
      class PictureActions{
          +read_pictures(db: Session)
          +read_picture_by_id(db: Session, id: int)
          +read_picture_by_path(db: Session, path: str)
          +read_user_pictures(db: Session, user_id: int)
          +browse_user_pictures(db: Session, user_id, hair_style, hair_colour ace_shape)
          +browse_pictures(db: Session,] hair_style hair_colour face_shape)
          +add_picture(db: Session, picture user_id)
          +edit_picture_by_path(db: Session, picture_path hair_style hair_colour face_shape)
          +edit_picture_by_id(db: Session, picture_id hair_style hair_colour face_shape)
          +delete_picture_by_path(db: Session, picture_path)
          +delete_picture_by_id(db: Session, picture_id)
      }
```

### Models

`models/pictures.py`
```python
from sqlalchemy import Column, Integer, String
from app.database.db import Base

class Picture(Base):
    __tablename__ = "pictures"
    id = Column(Integer, primary_key=True, index=True)
    file_name = Column(String(255), unique=True)
    file_path = Column(String(255))
    file_size = Column(Integer)
    height = Column(String(255))
    width = Column(String(255))
```
