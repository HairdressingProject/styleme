"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 10:16 pm
File: hair_style_link.py
"""
from pydantic import constr
from datetime import datetime

from pydantic import BaseModel


class HairStyleLinkBase(BaseModel):
    id: int
    hair_style_id: int
    link_name: str
    link_url: str


class HairStyleLinkCreateUpdate(HairStyleLinkBase):
    link_name: constr(max_length=128)
    link_url: constr(max_length=512)


class HairStyleLink(HairStyleLinkBase):
    date_created: datetime
    date_updated: datetime

    class Config:
        orm_mode = True
