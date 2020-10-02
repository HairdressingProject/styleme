"""
Project: PicturesAPI
Author: Diego C. <20026893@tafe.wa.edu.au>
Created at: 02/10/2020 7:47 pm
File: history.py
"""
from typing import List

from fastapi import APIRouter, File, Depends, UploadFile, status
from sqlalchemy.orm import Session
from app import services, actions, models, schemas
from app.database.db import SessionLocal, engine, Base
from app.settings import PICTURE_UPLOAD_FOLDER

router = APIRouter()
picture_service = services.PictureService()
picture_actions = actions.PictureActions()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


