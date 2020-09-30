from typing import Optional

from pydantic import BaseModel, constr, conint
from datetime import datetime


class PictureBase(BaseModel):
    id: int
    file_name: str
    file_path: str
    file_size: int
    height: int
    width: int


class PictureCreateUpdate(PictureBase):
    file_name: constr(max_length=255)
    file_path: constr(max_length=255)
    file_size: conint(ge=0)
    height: conint(ge=0)
    width: conint(ge=0)


class Picture(PictureBase):
    date_created: datetime
    date_updated: Optional[datetime] = None

    class Config:
        orm_mode = True
