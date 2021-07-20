import os
from .constants import DEV_DATABASE_URI
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base


SQL_DATABASE_URI = os.getenv("SQL_DATABASE_URI", DEV_DATABASE_URI)


engine = create_engine(SQL_DATABASE_URI)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db():    
    Base.metadata.create_all(bind=engine)
