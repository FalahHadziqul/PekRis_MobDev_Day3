import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  // Tahap 2 (Hive): Nantinya main() menginisialisasi Hive Box sebelum memanggil MyApp.
  runApp(const MyApp());
}

/// MyApp memegang konfigurasi global aplikasi.
/// Tampilan halaman sudah dipisah ke `lib/pages/home_page.dart` (Slicing UI).
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
      home: const HomePage(title: 'Workshop Flutter: Slicing UI'),
    );
  }
}
