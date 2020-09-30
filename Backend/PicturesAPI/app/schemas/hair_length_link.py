"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 29/09/2020 4:04 pm
File: hair_length_link.py
"""
from pydantic import constr
from datetime import datetime

from pydantic import BaseModel


class HairLengthLinkBase(BaseModel):
    id: int
    hair_length_id: int
    link_name: str
    link_url: str


class HairLengthLinkCreateUpdate(HairLengthLinkBase):
    link_name: constr(max_length=128)
    link_url: constr(max_length=512)


class HairLengthLink(HairLengthLinkBase):
    date_created: datetime
    date_updated: datetime

    class Config:
        orm_mode = True
