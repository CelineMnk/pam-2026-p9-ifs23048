import requests
from app.config import Config
from app.services.mahasiswa_service import get_all, get_statistik


def _chat(prompt: str) -> str:
    response = requests.post(
        f"{Config.LLM_BASE_URL}/llm/chat",
        json={
            "token": Config.LLM_TOKEN,
            "chat": prompt,
            "max_tokens": 500,    # ← tambah ini
            "credit": 500         # ← coba tambah ini
        },
        timeout=60,
    )

    print("STATUS:", response.status_code)
    print("RESPONSE:", response.text)

    if response.status_code != 200:
        raise Exception(f"LLM error: {response.text}")

    data = response.json()
    return data.get("data", str(data))

def analisis_kelas():
    data = get_all()
    stats = get_statistik()

    ringkasan = "\n".join([
        f"- {m['nama']}: Akhir={m['nilai_akhir']}, Grade={m['grade']}"
        for m in data
    ])

    prompt = f"""Analisis nilai mahasiswa Pemrograman Mobile:

{ringkasan}

Rata-rata: {stats['rata_rata']}, Lulus: {stats['lulus']}/{stats['total_mahasiswa']}

Berikan analisis singkat:
1. Ringkasan kelas
2. Mahasiswa bermasalah
3. Mahasiswa berprestasi
4. Rekomendasi untuk dosen"""

    return _chat(prompt)


def rekomendasi_mahasiswa(nim: str):
    from app.services.mahasiswa_service import get_by_nim
    m = get_by_nim(nim)
    if not m:
        return None, "Mahasiswa tidak ditemukan"

    prompt = f"""Rekomendasi untuk {m['nama']} (Grade {m['grade']}, Nilai {m['nilai_akhir']}):
UTS={m['nilai_uts']}, UAS={m['nilai_uas']}, Tugas={m['nilai_tugas']}

Berikan rekomendasi singkat:
1. Penilaian
2. Kekuatan
3. Area perbaikan
4. Tips belajar"""

    return m, _chat(prompt)