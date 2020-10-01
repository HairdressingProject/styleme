from sqlalchemy import func, Column, BIGINT, String, DateTime
from sqlalchemy.dialects import mysql
from app.database.db import Base


class User(Base):
    """
    Users model class
    """
    __tablename__ = "users"
    id = Column(BIGINT, primary_key=True, index=True)
    user_name = Column(String(32), unique=True, nullable=False)
    user_password_hash = Column(String(512), nullable=False)
    user_password_salt = Column(String(512), nullable=False)
    user_email = Column(String(512), unique=True, nullable=False)
    first_name = Column(String(128), nullable=False, default="user")
    last_name = Column(String(128))
    user_role = Column(mysql.ENUM("user", "developer", "admin"), nullable=False, server_default="user")
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())
