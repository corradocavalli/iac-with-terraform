from fastapi import (
    FastAPI
)

from settings.tags import (
    tags_metadata
)
from saas.models import (
    init_db
)
from routers import (
    customers    
)

app = FastAPI(openapi_tags=tags_metadata)

app.include_router(customers.router)

init_db()


@app.get("/")
async def root():
    return {"message": "Hello Bigger Applications!"}
