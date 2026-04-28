from db.data import MAHASISWA

def hitung_nilai_akhir(uts, uas, tugas):
    return round(uts * 0.3 + uas * 0.4 + tugas * 0.3, 2)

def nilai_ke_grade(nilai):
    if nilai >= 80: return "A"
    elif nilai >= 70: return "B"
    elif nilai >= 60: return "C"
    elif nilai >= 50: return "D"
    else: return "E"

def get_all():
    result = []
    for m in MAHASISWA:
        na = hitung_nilai_akhir(m["nilai_uts"], m["nilai_uas"], m["nilai_tugas"])
        result.append({**m, "nilai_akhir": na, "grade": nilai_ke_grade(na)})
    return result

def get_statistik():
    data = get_all()
    nilai_list = [m["nilai_akhir"] for m in data]
    grades = {}
    for m in data:
        g = m["grade"]
        grades[g] = grades.get(g, 0) + 1
    return {
        "total_mahasiswa": len(data),
        "rata_rata": round(sum(nilai_list) / len(nilai_list), 2),
        "nilai_tertinggi": max(nilai_list),
        "nilai_terendah": min(nilai_list),
        "distribusi_grade": grades,
        "lulus": len([n for n in nilai_list if n >= 60]),
        "tidak_lulus": len([n for n in nilai_list if n < 60]),
    }

def get_by_nim(nim: str):
    data = get_all()
    return next((m for m in data if m["nim"] == nim), None)