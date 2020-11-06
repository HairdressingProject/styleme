from fastapi.testclient import TestClient
from fastapi import Depends
from app.main import app
from app import schemas
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.database import Base
from app.routers.pictures import get_db
from app.models.picture import Picture
from sqlalchemy.orm import Session
from datetime import datetime
import hashlib
from app import actions

picture_actions = actions.PictureActions()

SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base.metadata.create_all(bind=engine)


def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db
client = TestClient(app)


def test_read_picture():
    response = client.get("/id/{picture_id}")
    assert response.status_code == 401

def test_read_pictures():
    response = client.get("")
    assert response.status_code == 200


# def test_add_picture() -> None:
#     temp_filename = "test_base_name" + ' - ' + str(datetime.now())
#     file_name = hashlib.md5(temp_filename.encode()).hexdigest()
#     file_path = '/some/file/path'
#     file_size = 752237
#     height = 647
#     width = 640
#     new_picture = schemas.PictureCreate(file_name=file_name, file_path=file_path, file_size=file_size, height=height,
#                                         width=width)
#     db_picture = picture_actions.add_picture(picture=new_picture, db=Depends(override_get_db))
#     assert db_picture.file_name == file_name
#     assert db_picture.file_path == file_path
#     assert db_picture.file_size == file_size
#     assert db_picture.height == height
#     assert db_picture.width == width
