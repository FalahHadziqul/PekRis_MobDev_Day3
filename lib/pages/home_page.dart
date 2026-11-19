import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/note_input_bar.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/quick_note_tile.dart';
import '../widgets/stat_card.dart';

/// Halaman utama hasil Slicing UI + Hive Simpel:
/// State daftar catatan sekarang dibaca & disimpan ke Hive Box (`notesBox`).
/// Semua file di `lib/widgets/` tetap utuh tanpa perlu diubah.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Box<String> _notesBox;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesBox = Hive.box<String>('notesBox');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    _notesBox.add(text);
    _noteController.clear();
    setState(() {});
  }

  void _deleteNoteAt(int index) {
    _notesBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final notes = _notesBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Komponen Header
          const ProfileHeaderCard(
            title: 'Halo, Flutter Learner!',
            subtitle: 'Belajar Slicing UI & Local Storage',
            badgeLabel: 'Day 3',
          ),
          const SizedBox(height: 16),

          // 2. Komponen Reusable StatCard
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Total Catatan',
                  value: '${notes.length}',
                  icon: Icons.notes_rounded,
                  accentColor: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  title: 'Penyimpanan',
                  value: 'Hive',
                  icon: Icons.storage_rounded,
                  accentColor: colorScheme.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Komponen Input Catatan
          Text(
            'Catatan Cepat',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          NoteInputBar(controller: _noteController, onAdd: _addNote),
          const SizedBox(height: 12),

          // 4. Daftar Catatan dari Hive Box
          if (notes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Belum ada catatan. Tambahkan satu di atas!',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ...List.generate(
              notes.length,
              (index) => QuickNoteTile(
                note: notes[index],
                onDelete: () => _deleteNoteAt(index),
              ),
            ),
        ],
      ),
    );
  }
}
