"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 9:23 pm
File: hair_colour.py
"""
from datetime import datetime
from typing import Optional

from pydantic import BaseModel, constr


class HairColourBase(BaseModel):
    id: int
    colour_name: str
    colour_hash: str
    label: str


class HairColourCreateUpdate(HairColourBase):
    colour_name: constr(max_length=64)
    colour_hash: constr(max_length=64, regex="^(#[a-fA-F0-9]{3}$)|(#[a-fA-F0-9]{6}$)")


class HairColour(HairColourBase):
    date_created: datetime
    date_updated: Optional[datetime] = None

    class Config:
        orm_mode = True
