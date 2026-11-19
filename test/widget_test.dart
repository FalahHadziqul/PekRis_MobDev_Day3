import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pekris_day3/main.dart';

void main() {
  testWidgets('Slicing UI smoke test: add and delete notes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Kondisi awal: 2 catatan contoh tampil di QuickNoteTile & StatCard.
    expect(find.text('2'), findsOneWidget); // StatCard total catatan
    expect(find.text('Memori'), findsOneWidget); // StatCard penyimpanan
    expect(find.text('Pecah UI jadi komponen kecil (Slicing)'), findsOneWidget);

    // Uji tambah catatan baru lewat NoteInputBar.
    await tester.enterText(find.byType(TextField), 'Catatan baru dari test');
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    expect(find.text('Catatan baru dari test'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // Uji hapus catatan pertama lewat QuickNoteTile.
    await tester.tap(find.byTooltip('Hapus Catatan').first);
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
  });
}
