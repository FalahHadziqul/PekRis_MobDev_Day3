import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:pekris_day3/main.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<String>('notesBox');
  });

  setUp(() async {
    await Hive.box<String>('notesBox').clear();
  });

  tearDownAll(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {
      // Pada Windows, handle file Hive kadang masih terbuka sampai proses test berakhir.
    }
  });

  testWidgets('Slicing UI + Hive persistence smoke test for quick notes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Kondisi awal: catatan kosong (0) dan status penyimpanan Hive.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Hive'), findsOneWidget);
    expect(
      find.text('Belum ada catatan. Tambahkan satu di atas!'),
      findsOneWidget,
    );

    // Tambah catatan dan pastikan tersimpan di notesBox.
    await tester.enterText(find.byType(TextField), 'Belajar Hive Simpel');
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    expect(find.text('Belajar Hive Simpel'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(Hive.box<String>('notesBox').values.toList(), [
      'Belajar Hive Simpel',
    ]);

    // Simulasi restart aplikasi dengan membangun ulang root widget MyApp.
    await tester.pumpWidget(MyApp(key: UniqueKey()));
    await tester.pumpAndSettle();

    expect(find.text('Belajar Hive Simpel'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    // Hapus catatan dan pastikan terhapus dari notesBox.
    await tester.tap(find.byTooltip('Hapus Catatan'));
    await tester.pump();
    expect(find.text('Belajar Hive Simpel'), findsNothing);
    expect(find.text('0'), findsOneWidget);
    expect(Hive.box<String>('notesBox').isEmpty, isTrue);
  });
}
