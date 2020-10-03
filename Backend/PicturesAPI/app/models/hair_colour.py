"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 9:23 pm
File: hair_colour.py
"""
from sqlalchemy import func, Column, BIGINT, String, DateTime, text
from app.database.db import Base


class HairColour(Base):
    __tablename__ = "colours"
    id = Column(BIGINT, primary_key=True, index=True)
    colour_name = Column(String(64), nullable=False, server_default="** ERROR: missing category **")
    colour_hash = Column(String(64), nullable=False, server_default="** ERROR: missing category **")
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), server_default=text("NULL"), onupdate=func.now())
