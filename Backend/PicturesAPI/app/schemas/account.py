"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 28/09/2020 8:44 pm
File: account.py
"""
from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class AccountBase(BaseModel):
    user_id: int
    recover_password_token: str
    account_confirmed: bool
    unusual_activity: bool


class Account(AccountBase):
    date_created: datetime
    date_updated: Optional[datetime] = None

    class Config:
        orm_mode = True
