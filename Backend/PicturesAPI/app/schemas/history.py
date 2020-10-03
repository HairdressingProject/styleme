"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:57 pm
File: history.py
"""
from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class HistoryBase(BaseModel):
    id: int
    picture_id: int
    original_picture_id: Optional[int] = None
    previous_picture_id: Optional[int] = None
    hair_colour_id: Optional[int] = None
    hair_style_id: Optional[int] = None
    face_shape_id: Optional[int] = None
    user_id: int


class HistoryCreate(BaseModel):
    picture_id: int
    original_picture_id: Optional[int] = None
    previous_picture_id: Optional[int] = None
    hair_colour_id: Optional[int] = None
    hair_style_id: Optional[int] = None
    face_shape_id: Optional[int] = None
    user_id: int


class HistoryUpdate(HistoryBase):
    pass


class History(HistoryBase):
    date_created: datetime
    date_updated: Optional[datetime] = None

    class Config:
        orm_mode = True
