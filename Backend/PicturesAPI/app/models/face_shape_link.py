"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 29/09/2020 4:07 pm
File: face_shape_link.py
"""
from sqlalchemy import func, Column, String, BIGINT, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database.db import Base

from .face_shape import FaceShape


class FaceShapeLinks(Base):
    __tablename__ = "face_shape_links"
    id = Column(BIGINT, primary_key=True, index=True)
    face_shape_id = Column(BIGINT, ForeignKey("face_shapes.id"), nullable=False)
    link_name = Column(String(128), nullable=False, server_default="** ERROR: missing category **")
    link_url = Column(String(512), nullable=False, server_default="** ERROR: missing category **")
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())

    face_shape = relationship("FaceShape", back_populates="face_shape_links")

    def __repr__(self):
        return "<Hair length (face_shape_id = '%s') link>" % self.face_shape_id


FaceShape.face_shape_links = relationship(
    "FaceShapeLinks", order_by=FaceShapeLinks.date_updated,
    back_populates="face_shape", cascade="all, delete"
)
