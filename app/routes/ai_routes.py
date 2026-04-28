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
        print("ERROR ANALISIS:", str(e))
        import traceback
        traceback.print_exc()
        return jsonify({"analisis": str(e), "status": "error"}), 500

@ai_bp.route("/rekomendasi/<nim>", methods=["GET"])
@require_auth
def rekomendasi(nim):
    try:
        mahasiswa, hasil = rekomendasi_mahasiswa(nim)
        if not mahasiswa:
            return jsonify({"error": hasil}), 404
        return jsonify({"mahasiswa": mahasiswa, "rekomendasi": hasil, "status": "success"})
    except Exception as e:
        print("ERROR REKOMENDASI:", str(e))
        import traceback
        traceback.print_exc()
        return jsonify({"rekomendasi": str(e), "status": "error"}), 500