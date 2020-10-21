"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 19/10/2020 12:38 pm
File: hair_colour_actions.py
"""
from typing import List

from sqlalchemy.orm import Session

from app import models


class HairColourActions:
    def get_hair_colours(self, db: Session, skip: int = 0, limit: int = 100, search: str = "") -> List[models.HairColour]:
        if not search.strip():
            return db.query(models.HairColour).offset(skip).limit(limit).all()
        return db.query(models.HairColour).filter(models.HairColour.colour_name.ilike('%' + search + '%')).offset(
            skip).limit(limit).all()
    
    def get_hair_colour_by_id(self, db: Session, hair_colour_id: int):
        return db.query(models.HairColour).filter(models.HairColour.id == hair_colour_id).first()
