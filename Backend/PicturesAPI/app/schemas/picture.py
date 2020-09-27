from pydantic import BaseModel


class PictureBase(BaseModel):
    file_name: str
    file_path: str
    file_size: int
    height: int
    width: int


class PictureCreate(PictureBase):
    pass


class Picture(PictureBase):
    id: int

    class Config:
        orm_mode = True