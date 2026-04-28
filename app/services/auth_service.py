from db.data import USERS
from app.models.user_model import UserModel

def authenticate(username: str, password: str):
    user = USERS.get(username)
    if not user or user["password"] != password:
        return None
    return UserModel(username, user["name"], user["role"])