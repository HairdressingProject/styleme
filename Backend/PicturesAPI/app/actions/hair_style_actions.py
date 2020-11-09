"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 19/10/2020 10:09 pm
File: hair_style_actions.py
"""
from typing import Optional, List, Union

from sqlalchemy.orm import Session

from app import models


class HairStyleActions:
    def get_hair_styles(self, db: Session, skip: Optional[int] = 0, limit: Optional[int] = 100,
                        search: Optional[str] = "") -> List[models.HairStyle]:
        """
        Retrieves all hair style records from the database
        :param db: db session instance
        :param skip: optionally skip a number of records (default = 0)
        :param limit: optionally limit the number of results retrieved (default = 1000)
        :param search: optionally search history records by username (default = "")
        :return: List of HairStyle class instance
        """
        if not search.strip():
            return db.query(models.HairStyle).offset(skip).limit(limit).all()
        return db.query(models.HairStyle).filter(models.HairStyle.hair_style_name.ilike('%' + search + '%')).offset(
            skip).limit(limit).all()

    def get_hair_style(self, db: Session, hair_style_id: int) -> Union[models.HairStyle, None]:
        """
        Retrieve a hair style record that matches the ID
        :param db: db session instance
        :param hair_style_id: ID of the selected hair style record
        :return: instance of HairStyle
        """
        return db.query(models.HairStyle).filter(models.HairStyle.id == hair_style_id).first()
