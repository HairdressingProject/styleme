"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:44 pm
File: account.py
"""
from sqlalchemy import func, Column, Integer, DateTime, Binary, Boolean, ForeignKey
from sqlalchemy.orm import relationship

from app.database.db import Base
from .user import User


class Account(Base):
    __tablename__ = "accounts"
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True, index=True)
    recover_password_token = Column(Binary(16), unique=True, server_default=None)
    account_confirmed = Column(Boolean, server_default=False)
    unusual_activity = Column(Boolean, server_default=False)
    date_created = Column(DateTime(timezone=True), server_default=func.now())
    date_updated = Column(DateTime(timezone=True), onupdate=func.now())

    user = relationship("User", back_populates="users")

    def __repr__(self):
        return "<User's account (user_id = '%s')>" % self.user_id


User.accounts = relationship(
    "Account", order_by=Account.date_updated, back_populates="user"
)
