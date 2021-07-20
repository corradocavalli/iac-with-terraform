import uuid


DEFAULT_ENCODERS = {
    uuid.UUID: lambda x: str(x),
}
