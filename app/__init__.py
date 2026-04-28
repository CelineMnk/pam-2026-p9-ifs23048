from flask import Flask
from app.config import Config
from flask_cors import CORS
from app.routes.auth_routes import auth_bp
from app.routes.mahasiswa_routes import mahasiswa_bp
from app.routes.ai_routes import ai_bp

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Fix CORS untuk web/Chrome
    CORS(app, resources={r"/api/*": {"origins": "*"}})

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(mahasiswa_bp, url_prefix="/api/mahasiswa")
    app.register_blueprint(ai_bp, url_prefix="/api/ai")

    @app.route("/")
    def index():
        return {"message": "PAM 2026 P9 - API Analisis Nilai Mahasiswa", "version": "1.0.0"}

    return app