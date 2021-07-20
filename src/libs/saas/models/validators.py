from .constants import PrivacyLevel
import pydantic
import re
from typing import List


def translate_inferencing_edge_modules(inferencing_edge_modules: List) -> List:
    """if inferencing_edge_modules is a list of SQLAlchemy models, we need to
    select the fields we need. Otherwise, Pydantic will raise a Serialization error.
    If instances of the list are already formatted, then, we just return the value without
    processing.

    """
    if all(isinstance(inferencing_edge_module, str) for inferencing_edge_module in inferencing_edge_modules):
        return inferencing_edge_modules
    translated_inferencing_edge_modules = list()
    for inferencing_edge_module in inferencing_edge_modules:
        translated_inferencing_edge_modules.append(inferencing_edge_module.id)
    return translated_inferencing_edge_modules


def name_check_some_special_characters(value: str) -> str:
    pattern = "^(?!.*?\\s{2})[ .a-zA-Z0-9_]+$"
    regex = re.compile(pattern)
    if type(value) is not str:
        raise ValueError("value must be a string")
    if not regex.search(value):
        raise ValueError("value should not contain characters such as !, ?, *, ...")
    return regex.search(value).string


def name_check_for_sense_app(value: str) -> str:
    """
    The below pattern makes sure that the name starts with com.
    Then, makes sure that there are:
    - no special characters
    - name not ending with a . (at least two characters after the .)
    """
    pattern = r"^(@?[a-z0-9]\w+(?:\-?[a-z0-9]\w+)*)$"  # noqa: W605
    regex = re.compile(pattern)
    if type(value) is not str:
        raise ValueError("value must be a string")
    if not regex.search(value):
        raise ValueError("value should be a namespace such as com-enablon-helmetchecker")
    return regex.search(value).string


def geolocation_check_structure(value) -> dict:
    if value == {} or value is None:
        return {}
    if set(value.keys()) != set(["latitude", "longitude"]):
        raise ValueError("Geolocation should be latitude and longitude.")
    return value


def privacy_level_check_value(value: int):
    if not value:
        return 0
    if value not in [p.value for p in PrivacyLevel]:
        raise ValueError("invalid privacy level")
    return value


def convert_uuid_to_str(uuid_value) -> str:
    if uuid_value is None:
        return None
    return str(uuid_value)


def convert_list_of_uuid_to_list_of_str(uuid_values: list) -> list:
    return [str(uuid_value) for uuid_value in uuid_values]


# validators


def inferencing_edge_modules_validator(field) -> classmethod:
    decorator = pydantic.validator(field, allow_reuse=True, pre=True)
    validator = decorator(translate_inferencing_edge_modules)
    return validator


def privacy_level_validator(field) -> classmethod:
    decorator = pydantic.validator(field, allow_reuse=True)
    validator = decorator(privacy_level_check_value)
    return validator


def geolocation_validator(field) -> classmethod:
    decorator = pydantic.validator(field, allow_reuse=True)
    validator = decorator(geolocation_check_structure)
    return validator


def name_validator(field: str) -> classmethod:
    decorator = pydantic.validator(field, allow_reuse=True)
    validator = decorator(name_check_some_special_characters)
    return validator


def sense_app_name_validator(field: str) -> classmethod:
    decorator = pydantic.validator(field, allow_reuse=True)
    validator = decorator(name_check_for_sense_app)
    return validator


def uuid_to_str_validator(field) -> classmethod:
    decorator = pydantic.validator(field, allow_reuse=True, pre=True)
    validator = decorator(convert_uuid_to_str)
    return validator


def convert_list_of_uuid_to_list_of_str_validator(field) -> classmethod:
    decorator = pydantic.validator(field, allow_reuse=True, pre=True)
    validator = decorator(convert_list_of_uuid_to_list_of_str)
    return validator
