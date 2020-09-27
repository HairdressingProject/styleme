from pathlib import Path
import os
from dotenv import load_dotenv
env_path = Path().absolute() / '.env'
load_dotenv(dotenv_path=env_path)

DB_USER = os.getenv("DB_USER")
DB_USER_PASSWORD = os.getenv("DB_USER_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
S3_AWS_ACCESS_KEY_ID = os.getenv("S3_AWS_ACCESS_KEY_ID")
S3_AWS_SECRET_ACCESS_KEY = os.getenv("S3_AWS_SECRET_ACCESS_KEY")
PICTURE_UPLOAD_FOLDER = os.getenv("PICTURE_UPLOAD_FOLDER")
PICTURE_PROCESSED_FOLDER = os.getenv("PICTURE_PROCESSED_FOLDER")
FACE_SHAPE_RESULTS_PATH = os.getenv("FACE_SHAPE_RESULTS_PATH")