"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:57 pm
File: history.py
"""
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, constr


class HistoryBase(BaseModel):
    id: int
    picture_id: int
    original_picture_id: int
    hair_colour_id: int
    hair_style_id: int
    face_shape_id: int
    user_id: int


class HistoryCreateUpdate(HistoryBase):
    pass


class History(HistoryBase):
    date_created: datetime
    date_updated: Optional[datetime] = None

    class Config:
        orm_mode = True
