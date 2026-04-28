from flask import Blueprint, jsonify
from app.services.mahasiswa_service import get_all, get_statistik
from app.utils.jwt_helper import require_auth

mahasiswa_bp = Blueprint("mahasiswa", __name__)

@mahasiswa_bp.route("/", methods=["GET"])
@require_auth
def list_mahasiswa():
    data = get_all()
    return jsonify({"data": data, "total": len(data)})

@mahasiswa_bp.route("/statistik", methods=["GET"])
@require_auth
def statistik():
    return jsonify(get_statistik())