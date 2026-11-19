import 'package:flutter/material.dart';

import '../widgets/note_input_bar.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/quick_note_tile.dart';
import '../widgets/stat_card.dart';

/// Halaman utama hasil Slicing UI:
/// Memegang state catatan sementara (di memori) dan menyusun 4 komponen widget anak.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Tahap 1 (Slicing): State masih disimpan di memori (hilang saat app di-restart).
  // Tahap 2 (Hive): State ini akan disambungkan ke Hive Box.
  final List<String> _notes = [
    'Pecah UI jadi komponen kecil (Slicing)',
    'Lanjut integrasi Hive untuk local storage',
  ];
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _notes.add(text);
      _noteController.clear();
    });
  }

  void _deleteNoteAt(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Komponen Header (komposisi Container, Row, CircleAvatar, Column, Badge)
          const ProfileHeaderCard(
            title: 'Halo, Flutter Learner!',
            subtitle: 'Belajar Slicing UI & Local Storage',
            badgeLabel: 'Day 3',
          ),
          const SizedBox(height: 16),

          // 2. Komponen Reusable (1 widget StatCard dipakai 2x dengan parameter berbeda)
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Total Catatan',
                  value: '${_notes.length}',
                  icon: Icons.notes_rounded,
                  accentColor: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  title: 'Penyimpanan',
                  value: 'Memori',
                  icon: Icons.memory_rounded,
                  accentColor: colorScheme.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Komponen Input Catatan (interaktif dengan callback onAdd)
          Text(
            'Catatan Cepat',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          NoteInputBar(controller: _noteController, onAdd: _addNote),
          const SizedBox(height: 12),

          // 4. Daftar Catatan dengan komponen QuickNoteTile
          if (_notes.isEmpty)
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
              _notes.length,
              (index) => QuickNoteTile(
                note: _notes[index],
                onDelete: () => _deleteNoteAt(index),
              ),
            ),
        ],
      ),
    );
  }
}
