"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 29/09/2020 4:04 pm
File: hair_length_links.py
"""
from sqlalchemy import func, Column, String, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database.db import Base

from .hair_length import HairLength


class HairLengthLinks(Base):
    __tablename__ = "hair_length_links"
    id = Column(Integer, primary_key=True, index=True)
    hair_length_id = Column(Integer, ForeignKey("hair_lengths.id"), nullable=False)
    link_name = Column(String(128), nullable=False, server_default="** ERROR: missing category **")
    link_url = Column(String(512), nullable=False, server_default="** ERROR: missing category **")
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())

    hair_length = relationship("HairLength", back_populates="hair_length_links")

    def __repr__(self):
        return "<Hair length (hair_length_id = '%s') link>" % self.hair_length_id


HairLength.hair_length_links = relationship(
    "HairLengthLinks", order_by=HairLengthLinks.date_updated,
    back_populates="hair_length", cascade="all, delete"
)
