"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:57 pm
File: history.py
"""
from sqlalchemy import func, Column, Integer, DateTime
from app.database.db import Base


class History(Base):
    __tablename__ = "history"
    id = Column(Integer, primary_key=True, index=True)
    picture_id = Column(Integer)
    original_picture_id = Column(Integer)
    hair_colour_id = Column(Integer)
    hair_style_id = Column(Integer)
    face_shape_id = Column(Integer)
    user_id = Column(Integer)
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())
