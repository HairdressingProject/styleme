"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:57 pm
File: history.py
"""
from sqlalchemy import func, Column, BIGINT, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from app.database.db import Base
from .face_shape import FaceShape
from .hair_colour import HairColour
from .hair_style import HairStyle
from .picture import Picture
from .user import User


class History(Base):
    __tablename__ = "history"
    id = Column(BIGINT, primary_key=True, index=True)
    picture_id = Column(BIGINT, ForeignKey("pictures.id"), index=True)
    original_picture_id = Column(BIGINT, ForeignKey("pictures.id"), index=True)
    previous_picture_id = Column(BIGINT, ForeignKey("pictures.id"), index=True)
    hair_colour_id = Column(BIGINT, ForeignKey("colours.id"), index=True)
    hair_style_id = Column(BIGINT, ForeignKey("hair_styles.id"), index=True)
    face_shape_id = Column(BIGINT, ForeignKey("face_shapes.id"), index=True)
    user_id = Column(BIGINT, ForeignKey("users.id"), index=True)
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())

    picture = relationship("Picture", back_populates="history", foreign_keys=[picture_id])
    original_picture = relationship("Picture", back_populates="original_history", foreign_keys=[original_picture_id])
    previous_picture = relationship("Picture", back_populates="previous_history", foreign_keys=[previous_picture_id])
    hair_colour = relationship("HairColour", back_populates="history")
    hair_style = relationship("HairStyle", back_populates="history")
    face_shape = relationship("FaceShape", back_populates="history")
    user = relationship("User", back_populates="history")

    def __repr__(self):
        return 'History entry:\n' + \
               f'id: {self.id}\n' + \
               f'picture_id: {self.picture_id}\n' + \
               f'original_picture_id: {self.original_picture_id}\n' + \
               f'previous_picture_id: {self.previous_picture_id}\n' + \
               f'hair_colour_id: {self.hair_colour_id}\n' + \
               f'hair_style_id: {self.hair_style_id}\n' + \
               f'face_shape_id: {self.face_shape_id}\n' + \
               f'user_id: {self.user_id}\n' + \
               f'date_created: {self.date_created}\n' + \
               f'date_updated: {self.date_updated}\n'


Picture.history = relationship(
    "History", back_populates="picture", foreign_keys=[History.picture_id], cascade="all, delete-orphan, save-update"
)

Picture.original_history = relationship(
    "History", back_populates="original_picture", foreign_keys=[History.original_picture_id],
    cascade="all, delete-orphan, save-update"
)

Picture.previous_history = relationship(
    "History", back_populates="previous_picture", foreign_keys=[History.previous_picture_id],
    cascade="all, delete-orphan, save-update"
)

User.history = relationship(
    "History", order_by=History.date_updated, back_populates="user", cascade="all, delete-orphan"
)

HairColour.history = relationship(
    "History", back_populates="hair_colour", cascade="all, delete-orphan, save-update"
)

HairStyle.history = relationship(
    "History", back_populates="hair_style", cascade="all, delete-orphan, save-update"
)

FaceShape.history = relationship(
    "History", back_populates="face_shape", cascade="all, delete-orphan, save-update"
)
