import 'package:flutter/material.dart';

class NoteEditorMode extends StatelessWidget {
  const NoteEditorMode({
    super.key,
    required this.titleController,
    required this.noteController,
  });

  final TextEditingController titleController;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          decoration: const InputDecoration(
            hintText: 'Title',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
        Divider(
          height: 1,
          color: Theme.of(context).colorScheme.primary,
          thickness: 2,
        ),
        Expanded(
          child: TextField(
            controller: noteController,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.surface,
              filled: true,
              hintText: 'Note',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            expands: true,
            maxLines: null,
            minLines: null,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
          ),
        ),
      ],
    );
  }
}
