"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:53 pm
File: model_picture.py
"""
from pydantic import constr, conint
from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class ModelPictureBase(BaseModel):
    id: int
    file_name: str
    file_path: str
    file_size: int
    height: int
    width: int
    hair_style_id: Optional[int] = None
    hair_length_id: Optional[int] = None
    face_shape_id: int
    hair_colour_id: Optional[int] = None


# class ModelPictureCreateUpdate(ModelPictureBase):
#     file_name: constr(max_length=255)
#     file_path: constr(max_length=255)
#     file_size: conint(ge=0)
#     height: conint(ge=0)
#     width: conint(ge=0)
#     hair_style_id: conint(ge=0)
#     hair_length_id: conint(ge=0)
#     hair_colour_id: conint(ge=0)
#     face_shape_id: conint(ge=0)

class ModelPictureCreate(BaseModel):
    file_name: str
    file_path: str
    file_size: int
    height: int
    width: int
    hair_style_id: Optional[int] = None
    hair_length_id: Optional[int] = None
    face_shape_id: int
    hair_colour_id: Optional[int] = None


class ModelPictureUpdate(BaseModel):
    id: int
    hair_style_id: Optional[int] = None
    hair_length_id: Optional[int] = None
    face_shape_id: Optional[int] = None
    hair_colour_id: Optional[int] = None


class ModelPicture(ModelPictureBase):
    date_created: datetime
    date_updated: Optional[datetime] = None

    class Config:
        orm_mode = True
