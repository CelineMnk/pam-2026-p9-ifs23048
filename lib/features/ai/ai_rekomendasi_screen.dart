import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../data/services/api_service.dart';

class AiRekomendasiScreen extends StatefulWidget {
  final Map<String, dynamic> mahasiswa;
  const AiRekomendasiScreen({super.key, required this.mahasiswa});

  @override
  State<AiRekomendasiScreen> createState() => _AiRekomendasiScreenState();
}

class _AiRekomendasiScreenState extends State<AiRekomendasiScreen> {
  String? _hasil;
  bool _loading = false;
  String? _error;

  Color get _gradeColor {
    switch (widget.mahasiswa['grade']) {
      case 'A': return Colors.green.shade700;
      case 'B': return Colors.blue.shade700;
      case 'C': return Colors.orange.shade700;
      case 'D': return Colors.deepOrange.shade700;
      default: return Colors.red.shade700;
    }
  }

  Future<void> _get() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = null; _hasil = null; });
    try {
      final res = await ApiService.getAiRekomendasi(widget.mahasiswa['nim']);
      if (!mounted) return;  // ← tambah ini
      if (res['statusCode'] == 200) {
        setState(() { _hasil = res['rekomendasi']; _loading = false; });
      } else {
        setState(() { _error = 'Gagal'; _loading = false; });
      }
    } catch (e) {
      if (!mounted) return;  // ← tambah ini
      setState(() { _error = 'Koneksi gagal: $e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mahasiswa;
    return Scaffold(
      appBar: AppBar(
        title: Text(m['nama']),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Info Mahasiswa
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: _gradeColor.withOpacity(0.12),
                  child: Text(m['grade'], style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _gradeColor)),
                ),
                const SizedBox(height: 10),
                Text(m['nama'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('NIM: ${m['nim']}', style: const TextStyle(color: Colors.grey)),
                const Divider(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _NilaiBox('UTS\n(30%)', '${m['nilai_uts']}'),
                  _NilaiBox('UAS\n(40%)', '${m['nilai_uas']}'),
                  _NilaiBox('Tugas\n(30%)', '${m['nilai_tugas']}'),
                ]),
                const SizedBox(height: 10),
                Chip(
                  label: Text('Nilai Akhir: ${m['nilai_akhir']}',
                      style: TextStyle(color: _gradeColor, fontWeight: FontWeight.bold)),
                  backgroundColor: _gradeColor.withOpacity(0.1),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(height: 46,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _get,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _loading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.psychology),
              label: Text(_loading ? 'AI sedang memproses...' : 'Dapatkan Rekomendasi AI'),
            ),
          ),

          const SizedBox(height: 12),

          if (_loading)
            const Card(child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Menyusun rekomendasi personal...', style: TextStyle(color: Colors.grey)),
              ]),
            )),

          if (_error != null)
            Card(color: Colors.red.shade50,
                child: Padding(padding: const EdgeInsets.all(14),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)))),

          if (_hasil != null && !_loading)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Icon(Icons.auto_awesome, color: Color(0xFF1A237E)),
                    SizedBox(width: 8),
                    Text('Rekomendasi Personal AI',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E), fontSize: 16)),
                  ]),
                  const Divider(height: 20),
                  MarkdownBody(data: _hasil!,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 14, height: 1.6),
                      h2: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}

class _NilaiBox extends StatelessWidget {
  final String label, value;
  const _NilaiBox(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
  ]);
}