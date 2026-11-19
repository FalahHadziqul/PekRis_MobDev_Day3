import 'package:flutter/material.dart';

/// Komponen input catatan cepat yang tersusun dari Row, TextField, dan FilledButton.
/// Controller masuk dari parent dan aksi simpan dilaporkan kembali lewat callback [onAdd].
class NoteInputBar extends StatelessWidget {
  const NoteInputBar({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onAdd(),
            decoration: InputDecoration(
              hintText: 'Tulis catatan singkat...',
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Simpan'),
        ),
      ],
    );
  }
}
