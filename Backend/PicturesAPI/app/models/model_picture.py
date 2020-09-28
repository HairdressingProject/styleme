"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:53 pm
File: model_picture.py
"""
from sqlalchemy import Column, Integer, String
from app.database.db import Base
from .picture import Picture


class ModelPicture(Base):
    __tablename__ = "model_pictures"
    id = Column(Integer, primary_key=True, index=True)
    file_name = Column(String(255), unique=True)
    file_path = Column(String(255))
    file_size = Column(Integer)
    height = Column(String(255))
    width = Column(String(255))
    hair_style_id = Column(Integer)
    hair_length_id = Column(Integer)
    face_shape_id = Column(Integer)
    hair_colour_id = Column(Integer)
