class MahasiswaModel {
  final String nim;
  final String nama;
  final int nilaiUts;
  final int nilaiUas;
  final int nilaiTugas;
  final double nilaiAkhir;
  final String grade;

  MahasiswaModel({
    required this.nim,
    required this.nama,
    required this.nilaiUts,
    required this.nilaiUas,
    required this.nilaiTugas,
    required this.nilaiAkhir,
    required this.grade,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) => MahasiswaModel(
    nim: json['nim'],
    nama: json['nama'],
    nilaiUts: json['nilai_uts'],
    nilaiUas: json['nilai_uas'],
    nilaiTugas: json['nilai_tugas'],
    nilaiAkhir: (json['nilai_akhir'] as num).toDouble(),
    grade: json['grade'],
  );
}