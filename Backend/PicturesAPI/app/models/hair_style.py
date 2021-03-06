"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 9:19 pm
File: hair_style.py
"""
from sqlalchemy import func, Column, String, BIGINT, DateTime, text
from app.database.db import Base


class HairStyle(Base):
    __tablename__ = "hair_styles"
    id = Column(BIGINT, primary_key=True, index=True)
    hair_style_name = Column(String(128), nullable=False, unique=True)
    label = Column(String(255))
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), server_default=text("NULL"), onupdate=func.now())
