"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:44 pm
File: account.py
"""
from sqlalchemy import func, Column, Integer, DateTime, Binary, Boolean, ForeignKey, text
from sqlalchemy.orm import relationship

from app.database.db import Base
from .user import User


class Account(Base):
    __tablename__ = "accounts"
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True, index=True)
    recover_password_token = Column(Binary(16), unique=True)
    account_confirmed = Column(Boolean, server_default=text("0"))
    unusual_activity = Column(Boolean, server_default=text("0"))
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())

    user = relationship(
        "User", back_populates="account",
        cascade="all, delete-orphan",
        single_parent=True
    )

    def __repr__(self):
        return "<User's account (user_id = '%s')>" % self.user_id


User.account = relationship(
    "Account", back_populates="user"
)
