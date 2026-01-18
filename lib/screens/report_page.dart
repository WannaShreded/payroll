import 'package:flutter/material.dart';

/// Reports feature has been removed. This page now shows a simple notice
/// so any remaining imports or references won't break the build.
class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Fitur Laporan telah dihapus',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Menu dan fungsi laporan telah dinonaktifkan. Jika Anda membutuhkan data laporan, gunakan halaman lain atau hubungi admin.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
