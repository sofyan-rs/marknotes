import 'package:flutter/material.dart';

class NoteEditorMode extends StatelessWidget {
  const NoteEditorMode({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.noteController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              hintText: 'Title',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              errorStyle: TextStyle(fontSize: 14),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 4),
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 2),
          Expanded(
            child: TextFormField(
              controller: noteController,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                hintText: 'Note',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                errorStyle: TextStyle(height: 5, fontSize: 14),
              ),
              expands: true,
              maxLines: null,
              minLines: null,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a note';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
