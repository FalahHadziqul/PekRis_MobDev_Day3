import 'package:flutter/material.dart';

/// Komponen item catatan singkat yang tersusun dari Card dan ListTile.
class QuickNoteTile extends StatelessWidget {
  const QuickNoteTile({super.key, required this.note, required this.onDelete});

  final String note;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.sticky_note_2_outlined,
          color: colorScheme.primary,
        ),
        title: Text(note),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Hapus Catatan',
          onPressed: onDelete,
        ),
      ),
    );
  }
}
