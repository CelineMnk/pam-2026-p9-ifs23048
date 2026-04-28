from flask import Blueprint, jsonify
from app.services.ai_service import analisis_kelas, rekomendasi_mahasiswa
from app.utils.jwt_helper import require_auth

ai_bp = Blueprint("ai", __name__)

@ai_bp.route("/analisis", methods=["POST"])
@require_auth
def analisis():
    try:
        hasil = analisis_kelas()
        return jsonify({"analisis": hasil, "status": "success"})
    except Exception as e:
        print("ERROR ANALISIS:", str(e))  # ← tambah ini
        import traceback
        traceback.print_exc()             # ← tambah ini
        return jsonify({"analisis": str(e), "status": "error"}), 500