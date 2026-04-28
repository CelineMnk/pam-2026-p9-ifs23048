import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY", "pam2026-secret-key")
    LLM_BASE_URL = os.environ.get("LLM_BASE_URL", "https://delcom.org/api")
    LLM_TOKEN = os.environ.get("LLM_TOKEN", "")
    APP_PORT = int(os.environ.get("APP_PORT", 5000))