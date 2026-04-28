import requests
from flask import current_app
from app.services.mahasiswa_service import get_all, get_statistik

def _chat(prompt: str, max_tokens: int = 1500) -> str:
    """Kirim prompt ke LLM API delcom.org"""
    base_url = current_app.config["LLM_BASE_URL"]
    token = current_app.config["LLM_TOKEN"]

    response = requests.post(
        f"{base_url}/v1/chat/completions",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        json={
            "model": "gpt-4o-mini",  # sesuaikan dengan model yang tersedia di delcom
            "max_tokens": max_tokens,
            "messages": [
                {"role": "user", "content": prompt}
            ],
        },
        timeout=60,
    )

    response.raise_for_status()
    data = response.json()
    return data["choices"][0]["message"]["content"]


def analisis_kelas():
    data = get_all()
    stats = get_statistik()

    ringkasan = "\n".join([
        f"- {m['nama']} (NIM: {m['nim']}): UTS={m['nilai_uts']}, "
        f"UAS={m['nilai_uas']}, Tugas={m['nilai_tugas']}, "
        f"Akhir={m['nilai_akhir']}, Grade={m['grade']}"
        for m in data
    ])

    prompt = f"""Kamu adalah asisten analisis akademik. Berikut data nilai mahasiswa mata kuliah Pemrograman Mobile:

{ringkasan}

Statistik:
- Total: {stats['total_mahasiswa']} mahasiswa
- Rata-rata: {stats['rata_rata']}
- Lulus: {stats['lulus']}, Tidak Lulus: {stats['tidak_lulus']}

Berikan analisis dalam Bahasa Indonesia yang mencakup:
1. **Ringkasan Performa Kelas**
2. **Identifikasi Mahasiswa Bermasalah**
3. **Mahasiswa Berprestasi**
4. **Pola yang Ditemukan**
5. **Rekomendasi Tindakan untuk Dosen**"""

    return _chat(prompt, max_tokens=1500)


def rekomendasi_mahasiswa(nim: str):
    from app.services.mahasiswa_service import get_by_nim
    m = get_by_nim(nim)
    if not m:
        return None, "Mahasiswa tidak ditemukan"

    prompt = f"""Kamu adalah konselor akademik. Berikan rekomendasi personal dalam Bahasa Indonesia untuk:

Nama: {m['nama']} | NIM: {m['nim']}
UTS: {m['nilai_uts']} | UAS: {m['nilai_uas']} | Tugas: {m['nilai_tugas']}
Nilai Akhir: {m['nilai_akhir']} | Grade: {m['grade']}

Berikan:
1. **Penilaian Singkat**
2. **Kekuatan**
3. **Area Perbaikan**
4. **3 Tips Belajar Konkret**
5. **Target Realistis Semester Depan**"""

    return m, _chat(prompt, max_tokens=800)