from sqlalchemy import func, Column, Integer, String, DateTime
from app.database.db import Base
from enum import Enum


class UserRoles(Enum):
    ADMIN = "admin"
    DEVELOPER = "developer"
    USER = "user"


class User(Base):
    """
    Users model class
    """
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    user_name = Column(String(32), unique=True, nullable=False)
    user_password_hash = Column(String(512), nullable=False)
    user_password_salt = Column(String(512), nullable=False)
    user_email = Column(String(512), unique=True, nullable=False)
    first_name = Column(String(128), nullable=False, default="user")
    last_name = Column(String(128))
    user_role = Column(UserRoles, nullable=False, default=UserRoles.USER)
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())
