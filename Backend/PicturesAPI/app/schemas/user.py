from typing import Optional
from enum import Enum

from pydantic import BaseModel, constr


class UserRoles(str, Enum):
    USER = "user"
    DEVELOPER = "developer"
    ADMIN = "admin"


class UserIn(BaseModel):
    user_name: constr(max_length=32)
    user_password: constr(max_length=128)
    user_email: constr(max_length=512)
    first_name: constr(max_length=128)
    last_name: constr(max_length=128)
    user_role: UserRoles = UserRoles.USER


class UserOut(BaseModel):
    id: int
    user_name: str
    user_email: str
    first_name: str
    last_name: Optional[str] = None
    user_role: str
    date_created: str
    date_updated: Optional[str] = None

    class Config:
        orm_mode = True


class UserInDB(BaseModel):
    user_name: str
    user_password_hash: str
    user_password_salt: str
    user_email: str
    first_name: str
    last_name: Optional[str] = None
    user_role: UserRoles = UserRoles.USER
