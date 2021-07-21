import enum


DEV_DATABASE_URI = "postgresql://postgres:secretpassword@localhost:5432/apidemo"


class PrivacyLevel(enum.IntEnum):
    low_privacy = 0
    middle_privacy = 1
    high_privacy = 2

    @classmethod
    def options(cls):
        """Returns a dictionary which can be used in select lists (e.g. web UI pull-downs)."""
        return [(m.value, m.name) for m in list(cls)]
