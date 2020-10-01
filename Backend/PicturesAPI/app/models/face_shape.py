"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 9:27 pm
File: face_shape.py
"""
from sqlalchemy import func, Column, String, BIGINT, DateTime, text
from app.database.db import Base


class FaceShape(Base):
    __tablename__ = "face_shapes"
    id = Column(BIGINT, primary_key=True, index=True)
    shape_name = Column(String(128), nullable=False, server_default="** ERROR: missing category **")
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), server_default=text("NULL"), onupdate=func.now())
