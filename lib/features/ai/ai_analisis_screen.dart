import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../data/services/api_service.dart';

class AiAnalisisScreen extends StatefulWidget {
  const AiAnalisisScreen({super.key});

  @override
  State<AiAnalisisScreen> createState() => _AiAnalisisScreenState();
}

class _AiAnalisisScreenState extends State<AiAnalisisScreen> {
  String? _hasil;
  bool _loading = false;
  String? _error;

  Future<void> _run() async {
    setState(() { _loading = true; _error = null; _hasil = null; });
    try {
      final res = await ApiService.getAiAnalisis();
      if (res['statusCode'] == 200) {
        setState(() { _hasil = res['analisis']; _loading = false; });
      } else {
        setState(() { _error = res['analisis'] ?? 'Gagal'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = 'Koneksi gagal: $e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: const Color(0xFF1A237E).withOpacity(0.07),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(children: [
                const Icon(Icons.psychology, size: 48, color: Color(0xFF1A237E)),
                const SizedBox(height: 8),
                const Text('Analisis AI Kelas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                const SizedBox(height: 6),
                const Text('AI akan menganalisis performa seluruh kelas secara otomatis.',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 14),
                SizedBox(width: double.infinity, height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _run,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: _loading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.auto_awesome),
                    label: Text(_loading ? 'AI sedang menganalisis...' : 'Jalankan Analisis AI'),
                  ),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 14),

          if (_loading)
            const Card(child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(children: [
                CircularProgressIndicator(),
                SizedBox(height: 14),
                Text('AI sedang membaca data nilai...', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              ]),
            )),

          if (_error != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            ),

          if (_hasil != null && !_loading)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Icon(Icons.auto_awesome, color: Color(0xFF1A237E)),
                    SizedBox(width: 8),
                    Text('Hasil Analisis AI', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E), fontSize: 16)),
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

          if (_hasil == null && _error == null && !_loading)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(children: [
                  Icon(Icons.analytics_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  Text('Klik tombol di atas untuk memulai analisis AI.',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500)),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}