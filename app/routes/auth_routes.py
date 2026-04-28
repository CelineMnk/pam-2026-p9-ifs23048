from flask import Blueprint, request, jsonify
from app.services.auth_service import authenticate
from app.utils.jwt_helper import generate_token, require_auth

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    user = authenticate(data.get("username", ""), data.get("password", ""))
    if not user:
        return jsonify({"error": "Username atau password salah"}), 401
    token = generate_token(user.to_dict())
    return jsonify({"token": token, "user": user.to_dict()})

@auth_bp.route("/me", methods=["GET"])
@require_auth
def me():
    return jsonify({"user": request.user})