"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:53 pm
File: model_picture.py
"""
from sqlalchemy import Column, Integer, BIGINT, String, ForeignKey
from sqlalchemy.orm import relationship
from app.database.db import Base
from .hair_style import HairStyle
from .hair_length import HairLength
from .face_shape import FaceShape
from .hair_colour import HairColour


class ModelPicture(Base):
    __tablename__ = "model_pictures"
    id = Column(BIGINT, primary_key=True, index=True)
    file_name = Column(String(255), unique=True, index=True)
    file_path = Column(String(255))
    file_size = Column(Integer)
    height = Column(Integer)
    width = Column(Integer)
    hair_style_id = Column(BIGINT, ForeignKey("hair_styles.id"))
    hair_length_id = Column(BIGINT, ForeignKey("hair_lengths.id"))
    face_shape_id = Column(BIGINT, ForeignKey("face_shapes.id"))
    hair_colour_id = Column(BIGINT, ForeignKey("colours.id"))

    hair_style = relationship(
        "HairStyle", back_populates="model_picture"
    )

    hair_length = relationship(
        "HairLength", back_populates="model_picture"
    )

    face_shape = relationship(
        "FaceShape", back_populates="model_picture"
    )

    hair_colour = relationship(
        "HairColour", back_populates="model_picture"
    )


HairStyle.model_picture = relationship(
    "ModelPicture", back_populates="hair_style"
)

HairLength.model_picture = relationship(
    "ModelPicture", back_populates="hair_length"
)

FaceShape.model_picture = relationship(
    "ModelPicture", back_populates="face_shape"
)

HairColour.model_picture = relationship(
    "ModelPicture", back_populates="hair_colour"
)
