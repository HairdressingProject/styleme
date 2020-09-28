"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:53 pm
File: model_picture.py
"""
from sqlalchemy import Column, Integer

from .picture import Picture


class ModelPicture(Picture):
    __tablename__ = "model_pictures"
    hair_style_id = Column(Integer)
    hair_length_id = Column(Integer)
    face_shape_id = Column(Integer)
    hair_colour_id = Column(Integer)
