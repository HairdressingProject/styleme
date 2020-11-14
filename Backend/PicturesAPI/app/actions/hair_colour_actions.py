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
        """
        Retrieve all hair colour records from the database
        :param db: db session instance
        :param skip: optionally skip a number of records (default = 0)
        :param limit: optionally limit the number of results retrieved (default = 1000)
        :param search: optionally search history records by username (default = "")
        :return: List of all HairColour class instances
        """
        if not search.strip():
            return db.query(models.HairColour).offset(skip).limit(limit).all()
        return db.query(models.HairColour).filter(models.HairColour.colour_name.ilike('%' + search + '%')).offset(
            skip).limit(limit).all()
    
    def get_hair_colour_by_id(self, db: Session, hair_colour_id: int) -> models.HairColour:
        """
        Retrieve a hair colour that matches the ID
        :param db: db session instance
        :param hair_colour_id: ID of the selected hair colour record
        :return: HairColour class instance
        """
        return db.query(models.HairColour).filter(models.HairColour.id == hair_colour_id).first()
