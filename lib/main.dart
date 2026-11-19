import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/home_page.dart';

Future<void> main() async {
  // Wajib dipanggil sebelum menjalankan plugin/async sebelum runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive dan buka Box untuk menyimpan daftar catatan secara lokal.
  await Hive.initFlutter();
  await Hive.openBox<String>('notesBox');

  runApp(const MyApp());
}

/// MyApp memegang konfigurasi global aplikasi.
/// Daftar catatan pada HomePage sekarang tersimpan secara persisten di Hive.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workshop Flutter - Slicing & Hive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const HomePage(title: 'Workshop Flutter: Slicing + Hive'),
    );
  }
}
