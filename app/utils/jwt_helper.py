import jwt
import datetime
from flask import current_app, request, jsonify
from functools import wraps

def generate_token(payload: dict) -> str:
    payload["exp"] = datetime.datetime.utcnow() + datetime.timedelta(hours=8)
    return jwt.encode(payload, current_app.config["SECRET_KEY"], algorithm="HS256")

def decode_token(token: str):
    try:
        return jwt.decode(token, current_app.config["SECRET_KEY"], algorithms=["HS256"])
    except (jwt.ExpiredSignatureError, jwt.InvalidTokenError):
        return None

def require_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth_header = request.headers.get("Authorization")
        if not auth_header or not auth_header.startswith("Bearer "):
            return jsonify({"error": "Token tidak ditemukan"}), 401
        token = auth_header.split(" ")[1]
        payload = decode_token(token)
        if not payload:
            return jsonify({"error": "Token tidak valid atau sudah kadaluarsa"}), 401
        request.user = payload
        return f(*args, **kwargs)
    return decorated