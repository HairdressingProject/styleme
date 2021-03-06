"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 10:16 pm
File: hair_style_link.py
"""
from sqlalchemy import func, Column, String, BIGINT, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database.db import Base

from .hair_style import HairStyle


class HairStyleLinks(Base):
    __tablename__ = "hair_style_links"
    id = Column(BIGINT, primary_key=True, index=True)
    hair_style_id = Column(BIGINT, ForeignKey("hair_styles.id"), nullable=False)
    link_name = Column(String(128), nullable=False, server_default="** ERROR: missing category **")
    link_url = Column(String(512), nullable=False, server_default="** ERROR: missing category **")
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())

    hair_style = relationship("HairStyle", back_populates="hair_style_links")

    def __repr__(self):
        return "<Hair style (hair_style_id = '%s') link>" % self.hair_style_id


HairStyle.hair_style_links = relationship(
    "HairStyleLinks", order_by=HairStyleLinks.date_updated,
    back_populates="hair_style", cascade="all, delete"
)
