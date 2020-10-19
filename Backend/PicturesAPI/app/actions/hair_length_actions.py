"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 19/10/2020 9:35 pm
File: hair_length_actions.py
"""
from typing import List, Union, Optional

from fastapi import Response, status
from sqlalchemy import desc
from sqlalchemy.orm import Session

from app import models, schemas


class HairLengthActions:
    def get_hair_lengths(self, db: Session, skip: Optional[int] = 0, limit: Optional[int] = 100,
                         search: Optional[str] = ""):
        if not search.strip():
            return db.query(models.HairLength).offset(skip).limit(limit).all()
        return db.query(models.HairLength).filter(models.HairLength.hair_length_name.ilike('%' + search + '%')).offset(
            skip).limit(limit).all()

    def get_hair_length(self, db: Session, hair_length_id: int):
        return db.query(models.HairLength).filter(models.HairLength.id == hair_length_id).first()
