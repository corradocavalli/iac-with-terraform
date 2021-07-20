from setuptools import (
    setup,
)

setup(
    name="saas",
    version="0.0.1",
    description="Core SQLAlchemy models used by Enablon Sense SaaS APIs",
    url="https://dev.azure.com/enablon/Sense-Microsoft/xxxx",
    author="Nolwen Brosson",
    author_email="nolwen.brosson@wolterskluwer.com",
    packages=["saas"],
    install_requires=[
        "sqlalchemy",
        "sqlalchemy-utils",
        "pydantic-sqlalchemy",
        "psycopg2",
    ],
)
