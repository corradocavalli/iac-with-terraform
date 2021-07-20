from datetime import datetime
import uuid
from .base_model import BaseMixin
from .json_encoders import DEFAULT_ENCODERS
from .validators import name_validator, uuid_to_str_validator, privacy_level_validator
from . import Base  # noqa: F401
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.dialects.postgresql import UUID
from pydantic_sqlalchemy import sqlalchemy_to_pydantic


class Customer(BaseMixin, Base):
    __tablename__ = "customer"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    name = Column(String, doc="testing doc", nullable=False, unique=True)
    privacy_level = Column(Integer, nullable=False)


class CustomerSchema(sqlalchemy_to_pydantic(Customer, exclude=["id", "created_at", "updated_at"])):
    # validators
    _ensure_name_meets_expected_format: classmethod = name_validator("name")
    _ensure_privacy_level_meets_expected_values: classmethod = privacy_level_validator("privacy_level")

    class Config:
        json_encoders = DEFAULT_ENCODERS


class CustomerResponseSchema(CustomerSchema):
    id: str
    created_at: datetime
    updated_at: datetime

    # validators
    _convert_uuid_to_str: classmethod = uuid_to_str_validator("id")
