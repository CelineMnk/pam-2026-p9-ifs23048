import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await ApiService.getStatistik();
      if (res['statusCode'] == 200) {
        setState(() { _stats = res; _loading = false; });
      } else {
        setState(() { _error = 'Gagal memuat statistik'; _loading = false; });
      }
    } catch (_) {
      setState(() { _error = 'Koneksi ke server gagal'; _loading = false; });
    }
  }

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
        Text(_error!, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        ElevatedButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: const Text('Coba Lagi')),
      ],
    ));

    final grades = Map<String, dynamic>.from(_stats!['distribusi_grade'] ?? {});
    final total = (_stats!['total_mahasiswa'] ?? 1) as int;

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard Statistik', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('Mata Kuliah: Pemrograman Mobile', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),

            Row(children: [
              _StatCard(label: 'Total Mahasiswa', value: '$total', icon: Icons.people, color: const Color(0xFF1A237E)),
              const SizedBox(width: 12),
              _StatCard(label: 'Rata-rata', value: '${_stats!['rata_rata']}', icon: Icons.bar_chart, color: Colors.blue.shade700),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _StatCard(label: 'Lulus', value: '${_stats!['lulus']}', icon: Icons.check_circle, color: Colors.green.shade700),
              const SizedBox(width: 12),
              _StatCard(label: 'Tidak Lulus', value: '${_stats!['tidak_lulus']}', icon: Icons.cancel, color: Colors.red.shade700),
            ]),

            const SizedBox(height: 20),
            const Text('Distribusi Grade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: ['A', 'B', 'C', 'D', 'E'].map((g) {
                    final count = (grades[g] ?? 0) as int;
                    final pct = total > 0 ? count / total : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(children: [
                        SizedBox(width: 52, child: Text('Grade $g', style: const TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: pct, minHeight: 20,
                            backgroundColor: Colors.grey.shade200,
                            color: _gradeColor(g),
                          ),
                        )),
                        const SizedBox(width: 8),
                        Text('$count mhs'),
                      ]),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Column(children: [
                    Text('${_stats!['nilai_tertinggi']}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                    const Text('Tertinggi', style: TextStyle(color: Colors.grey)),
                  ]),
                  Container(width: 1, height: 40, color: Colors.grey.shade300),
                  Column(children: [
                    Text('${_stats!['nilai_terendah']}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                    const Text('Terendah', style: TextStyle(color: Colors.grey)),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ]),
        ]),
      ),
    ),
  );
}