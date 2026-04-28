import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import '../ai/ai_rekomendasi_screen.dart';

class MahasiswaScreen extends StatefulWidget {
  const MahasiswaScreen({super.key});

  @override
  State<MahasiswaScreen> createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen> {
  List<dynamic> _data = [];
  bool _loading = true;
  String? _error;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await ApiService.getMahasiswa();
      if (res['statusCode'] == 200) {
        setState(() { _data = res['data']; _loading = false; });
      } else {
        setState(() { _error = 'Gagal memuat data'; _loading = false; });
      }
    } catch (_) {
      setState(() { _error = 'Koneksi gagal'; _loading = false; });
    }
  }

  List<dynamic> get _filtered => _search.isEmpty
      ? _data
      : _data.where((m) =>
  m['nama'].toString().toLowerCase().contains(_search.toLowerCase()) ||
      m['nim'].toString().contains(_search)).toList();

  Color _gradeColor(String g) {
    switch (g) {
      case 'A': return Colors.green.shade700;
      case 'B': return Colors.blue.shade700;
      case 'C': return Colors.orange.shade700;
      case 'D': return Colors.deepOrange.shade700;
      default: return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 12),
        Text(_error!),
        const SizedBox(height: 12),
        ElevatedButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: const Text('Coba Lagi')),
      ],
    ));

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(14),
        child: TextField(
          onChanged: (v) => setState(() => _search = v),
          decoration: InputDecoration(
            hintText: 'Cari nama atau NIM...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true, fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          ),
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            itemCount: _filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final m = _filtered[i];
              final grade = m['grade'] as String;
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.push(ctx,
                      MaterialPageRoute(builder: (_) => AiRekomendasiScreen(mahasiswa: m))),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      CircleAvatar(
                        backgroundColor: _gradeColor(grade).withOpacity(0.12),
                        child: Text(grade, style: TextStyle(color: _gradeColor(grade), fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(m['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('NIM: ${m['nim']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(children: [
                          _Chip('UTS: ${m['nilai_uts']}'),
                          const SizedBox(width: 4),
                          _Chip('UAS: ${m['nilai_uas']}'),
                          const SizedBox(width: 4),
                          _Chip('Tugas: ${m['nilai_tugas']}'),
                        ]),
                      ])),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('${m['nilai_akhir']}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _gradeColor(grade))),
                        const Text('Akhir', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ]),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
  );
}