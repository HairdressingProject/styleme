"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:57 pm
File: history.py
"""
from sqlalchemy import func, Column, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database.db import Base
from .user import User
from .hair_length import HairLength
from .hair_colour import HairColour
from .hair_style import HairStyle
from .face_shape import FaceShape
from .picture import Picture


class History(Base):
    __tablename__ = "history"
    id = Column(Integer, primary_key=True, index=True)
    picture_id = Column(Integer, ForeignKey("pictures.id"), index=True)
    original_picture_id = Column(Integer, ForeignKey("pictures.id"), index=True)
    previous_picture_id = Column(Integer, ForeignKey("pictures.id"), index=True)
    hair_colour_id = Column(Integer, ForeignKey("colours.id"), index=True)
    hair_style_id = Column(Integer, ForeignKey("hair_styles.id"), index=True)
    face_shape_id = Column(Integer, ForeignKey("face_shapes.id"), index=True)
    user_id = Column(Integer, ForeignKey("users.id"), index=True)
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())

    picture = relationship("Picture", back_populates="history")
    original_picture = relationship("Picture", back_populates="original_history")
    previous_picture = relationship("Picture", back_populates="previous_history")
    hair_colour = relationship("HairColour", back_populates="history")
    hair_style = relationship("HairStyle", back_populates="history")
    face_shape = relationship("FaceShape", back_populates="history")
    user = relationship("User", back_populates="history")

    def __repr__(self):
        return "<User's history entry (user_id = '%s')>" % self.user_id


Picture.history = relationship(
    "History", back_populates="picture"
)

Picture.original_history = relationship(
    "History", back_populates="original_picture"
)

Picture.previous_history = relationship(
    "History", back_populates="previous_picture"
)

User.history = relationship(
    "History", order_by=History.date_updated, back_populates="user"
)

HairColour.history = relationship(
    "History", back_populates="hair_colour"
)

HairStyle.history = relationship(
    "History", back_populates="hair_style"
)

FaceShape.history = relationship(
    "History", back_populates="face_shape"
)
