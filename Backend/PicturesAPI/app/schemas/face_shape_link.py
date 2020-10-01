"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 29/09/2020 4:07 pm
File: face_shape_link.py
"""
from pydantic import constr
from datetime import datetime

from pydantic import BaseModel


class FaceShapeLinkBase(BaseModel):
    id: int
    face_shape_id: int
    link_name: str
    link_url: str


class FaceShapeLinkCreateUpdate(FaceShapeLinkBase):
    link_name: constr(max_length=128)
    link_url: constr(max_length=512)


class FaceShapeLink(FaceShapeLinkBase):
    date_created: datetime
    date_updated: datetime

    class Config:
        orm_mode = True
