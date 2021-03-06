from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from app.settings import DB_NAME, DB_USER, DB_HOST, DB_USER_PASSWORD

SQLALCHEMY_DATABASE_URL = 'mysql+pymysql://' + DB_USER + ':' + DB_USER_PASSWORD + '@' + DB_HOST + '/' + DB_NAME + '?charset=utf8mb4'

engine = create_engine(
    SQLALCHEMY_DATABASE_URL
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
