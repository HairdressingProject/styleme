from sqlalchemy import Column, Integer, BIGINT, String, DateTime, func, text
from app.database.db import Base


class Picture(Base):
    __tablename__ = "pictures"
    id = Column(BIGINT, primary_key=True, index=True)
    file_name = Column(String(255), unique=True, index=True)
    file_path = Column(String(255))
    file_size = Column(Integer)
    height = Column(Integer)
    width = Column(Integer)
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), server_default=text("NULL"), onupdate=func.now())

    def __repr__(self):
        return 'Picture entry:' + \
               f'id: {self.id}\n' + \
               f'file_name: {self.file_name}\n' + \
               f'file_path: {self.file_path}\n' + \
               f'file_size: {self.file_size}\n' + \
               f'height: {self.height}\n' + \
               f'width: {self.width}\n' + \
               f'date_created: {self.date_created}\n' + \
               f'date_updated: {self.date_updated}\n'
