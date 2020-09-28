"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 9:19 pm
File: hair_style.py
"""
from sqlalchemy import func, Column, String, Integer, DateTime, text
from app.database.db import Base


class HairStyle(Base):
    __tablename__ = "hair_styles"
    id = Column(Integer, primary_key=True, index=True)
    hair_style_name = Column(String(128), nullable=False, server_default="** ERROR: missing category **")
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), server_default=text("NULL"), onupdate=func.now())
