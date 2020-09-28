from fastapi import FastAPI, File, Depends, UploadFile
from sqlalchemy.orm import Session
from app.database.db import SessionLocal, engine, Base
from app import services, actions, models

Base.metadata.create_all(bind=engine)
app = FastAPI()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.post("/pictures/upload")
async def save_picture(file: UploadFile = File(...), db: Session = Depends(get_db)):
    picture_service = services.PictureService()

    file_name = picture_service.save_picture(file)
    # return {file_name}

    face_detected = picture_service.detect_face(file_name)
    if face_detected is True:
        # crop picture and save in preprocessed folder
        picture_service.crop_picture(file_name)
        # add picture to db
        picture_info = picture_service.get_picture_info('pictures/original/', file_name)
        print(picture_info)
        new_picture = models.Picture(file_name=picture_info[1], file_path=picture_info[0], file_size=picture_info[2],
                                     height=picture_info[3], width=picture_info[4])
        picture_actions = actions.PictureActions()
        picture_actions.add_picture(db=db, picture=new_picture)
        # detect face_shape
        face_shape = picture_service.detect_face_shape(file_name)
        return face_shape
    else:
        return {"No face detected"}
    # return face_detected


@app.get("/pictures/detect_face")
async def detect_face(file_name: str, db: Session = Depends(get_db)):
    # ToDo:
    # before detecting face shape, check first if it is already checked
    # actions.read_picture()

    picture_service = services.PictureService()
    picture_actions = actions.PictureActions()
    face_detected = picture_service.detect_face(file_name)
    if face_detected is True:
        # crop picture and save in preprocessed folder
        picture_service.crop_picture(file_name)
        # add picture to db
        picture_info = picture_service.get_picture_info('pictures/original/', file_name)
        print(picture_info)
        new_picture = models.Picture(file_name=picture_info[1], file_path=picture_info[0], file_size=picture_info[2],
                                     height=picture_info[3], width=picture_info[4])
        picture_actions.add_picture(db=db, picture=new_picture)
    return face_detected


@app.get("/test")
async def test():
    return {"Test OK"}
