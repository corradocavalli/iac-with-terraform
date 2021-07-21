from setuptools import (
    setup,
)

setup(
    name="saas",
    version="0.0.1",
    description="Core SQLAlchemy models",
    url="https://mycompany.com/api/xxxx",
    author="",
    author_email="john.doe@mail.com",
    packages=["saas"],
    install_requires=[
        "sqlalchemy",
        "sqlalchemy-utils",
        "pydantic-sqlalchemy",
        "psycopg2",
    ],
)
