import requests
from app.config import Config
from app.services.mahasiswa_service import get_all, get_statistik


def _chat(prompt: str) -> str:
    response = requests.post(
        f"{Config.LLM_BASE_URL}/llm/chat",
        json={
            "token": Config.LLM_TOKEN,
            "chat": prompt
        },
        timeout=60,
    )

    print("STATUS:", response.status_code)
    print("RESPONSE:", response.text)

    if response.status_code != 200:
        raise Exception(f"LLM request failed: {response.text}")

    data = response.json()
    # Sesuaikan key response dengan yang dikembalikan delcom
    return data.get("data", data.get("message", str(data)))


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
1. Ringkasan Performa Kelas
2. Identifikasi Mahasiswa Bermasalah
3. Mahasiswa Berprestasi
4. Pola yang Ditemukan
5. Rekomendasi Tindakan untuk Dosen"""

    return _chat(prompt)


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
1. Penilaian Singkat
2. Kekuatan
3. Area Perbaikan
4. 3 Tips Belajar Konkret
5. Target Realistis Semester Depan"""

    return m, _chat(prompt)