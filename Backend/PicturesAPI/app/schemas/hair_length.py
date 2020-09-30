"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 9:26 pm
File: hair_length.py
"""
from datetime import datetime

from pydantic import BaseModel, constr


class HairLengthBase(BaseModel):
    id: int
    hair_length_name: str


class HairLengthCreateUpdate(HairLengthBase):
    hair_length_name: constr(max_length=128)


class HairLength(HairLengthBase):
    date_created: datetime
    date_updated: datetime

    class Config:
        orm_mode = True
