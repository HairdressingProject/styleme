"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 9:19 pm
File: hair_style.py
"""
from datetime import datetime

from pydantic import BaseModel, constr


class HairStyleBase(BaseModel):
    id: int
    hair_style_name: str


class HairStyleCreateUpdate(HairStyleBase):
    hair_style_name: constr(max_length=128)


class HairStyle(HairStyleBase):
    date_created: datetime
    date_updated: datetime

    class Config:
        orm_mode = True
