"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 9:27 pm
File: face_shape.py
"""
from pydantic import constr
from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class FaceShapeBase(BaseModel):
    id: int
    shape_name: str
    label: str


class FaceShapeCreateUpdate(FaceShapeBase):
    shape_name: constr(max_length=128)


class FaceShape(FaceShapeBase):
    date_created: datetime
    date_updated: Optional[datetime] = None

    class Config:
        orm_mode = True
