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
import requests

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


# def test_something():
#     response = requests.get("https://jsonplaceholder.typicode.com/todos/1")
#     assert response.status_code == 200

def test_users():

    response = client.get('http://localhost:5050/users')
    content = response.json()
    print(content)
    assert response.status_code == 401


def test_read_picture():

    response = client.get(
        "http://localhost:8000/pictures/id/1")
    print(response, "Response")
    assert response.status_code == 200
    content = response.json()
    print(content, "Content")
    assert content["id"] == 1


def test_read_pictures():
    response = client.get("https://localhost:8000/pictures",
                          headers={
                              "Origin": "https://styleme.best",
                              "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjEiLCJuYmYiOjE2MDQ2NjY4OTIsImV4cCI6MTYwNTI3MTY5MiwiaWF0IjoxNjA0NjY2ODkyLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo1MDAxIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1NTAwIn0.bqUCaKYES1nK4uqFe0Dz_yQJZC3afx6VNr4KtQ8TYNM"
                          }
                          )
    print(response.json())
    assert response.status_code == 200
