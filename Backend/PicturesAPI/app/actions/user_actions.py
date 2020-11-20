"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 16/11/2020 11:29 am
File: user_actions.py
"""
from typing import Optional

from sqlalchemy.orm import Session

from app import models


class UserActions:
    """
    CRUD operations related to User class
    """
    def get_user(self, user_id: int, db: Session) -> Optional[models.User]:
        """
        Retrieves a user identified by `user_id`

        :param user_id: ID of the user to be searched
        :param db: db session instance
        :returns: `User` found or None
        """
        user = db.query(models.User).filter(models.User.id == user_id).first()
        return user
