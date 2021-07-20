from .database import get_db


class BaseMixin:
    def delete(self, db=None):
        session = db or next(get_db())
        session.delete(self)
        return session.commit()

    def save(self, db=None):
        session = db or next(get_db())
        if self.id is None:
            session.add(self)
        return session.commit()

    @classmethod
    def query(cls, db=None):
        session = db or next(get_db())
        return session.query(cls)

    def __str__(self):
        return f"{self.__class__.__name__}: {self.name}"
