from fastapi import APIRouter, Depends, HTTPException
from typing import List
from saas.models.customer import (
    Customer,
    CustomerResponseSchema,
    CustomerSchema,
)
from saas.models.database import get_db
from sqlalchemy.orm import Session
from uuid import UUID


router = APIRouter(prefix="/customers", tags=["CUSTOMER MANAGEMENT"])


@router.get(
    "/",
    response_model=List[CustomerResponseSchema],
    status_code=200,
    name="Retrieve customers",
    description="Retrieve customers",
)
async def get_customers(skip: int = 0, limit: int = 20, name: str = None, db: Session = Depends(get_db)):
    filters = list()
    if name:
        filters.append(Customer.name == name)
    customers_query = db.query(Customer).filter(*filters).order_by(Customer.created_at.desc()).offset(skip).limit(limit)
    return customers_query.all()


@router.post(
    "/",
    response_model=CustomerResponseSchema,
    status_code=200,
    name="Add customer",
    description="Add a new customer",
)
async def post_customer(payload: CustomerSchema, db: Session = Depends(get_db)):
    filters = [Customer.name == payload.name]
    db_customer = db.query(Customer).filter(*filters).first()
    if db_customer:
        raise HTTPException(status_code=400, detail="Name already exists")
    new_record = Customer(**payload.dict())
    new_record.save(db)
    return new_record


@router.get(
    "/{customer_id}",
    response_model=CustomerResponseSchema,
    status_code=200,
    name="Retrieve specific customer",
    description="Retrieve a customer by customer id",
)
async def get_specific_customer(customer_id: UUID, db: Session = Depends(get_db)):
    filters = [Customer.id == customer_id]
    db_customer = db.query(Customer).filter(*filters).first()
    if not db_customer:
        raise HTTPException(status_code=400, detail="Id does not exists")
    return db_customer


@router.patch(
    "/{customer_id}",
    response_model=CustomerResponseSchema,
    status_code=200,
    name="Update specific customer",
    description="Update a customer by customer id",
)
async def update_specific_customer(customer_id: UUID, payload: CustomerSchema, db: Session = Depends(get_db)):
    filters = list()
    filters.append(Customer.name == payload.name)
    db_customer = db.query(Customer).filter(*filters).first()
    if db_customer:
        raise HTTPException(status_code=400, detail="Name already exists")
    filters = [Customer.id == customer_id]
    db_customer = db.query(Customer).filter(*filters).first()
    if not db_customer:
        raise HTTPException(status_code=400, detail="Site does not exist")
    for key in CustomerSchema.from_orm(db_customer).dict().keys():
        if getattr(payload, key, None):
            setattr(db_customer, key, getattr(payload, key))
    db_customer.save(db)
    return db_customer


@router.delete(
    "/{customer_id}",
    response_model=CustomerResponseSchema,
    status_code=200,
    name="Delete specific customer",
    description="Delete a customer by customer id",
)
async def delete_specific_customer(customer_id: UUID, db: Session = Depends(get_db)):
    filters = [Customer.id == customer_id]
    record_to_delete = db.query(Customer).filter(*filters).first()
    record_to_delete.delete(db)
    return record_to_delete
