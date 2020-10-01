from sqlalchemy import Column, Integer, String, DateTime, func, text
from app.database.db import Base


class Picture(Base):
    __tablename__ = "pictures"
    id = Column(Integer, primary_key=True, index=True)
    file_name = Column(String(255), unique=True)
    file_path = Column(String(255))
    file_size = Column(Integer)
    height = Column(Integer)
    width = Column(Integer)
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), server_default=text("NULL"), onupdate=func.now())
