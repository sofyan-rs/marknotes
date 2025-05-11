import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_app/features/notes/domain/entities/note_folder_entity.dart';
import 'package:markdown_app/features/notes/presentation/bloc/notes_folder_cubit/notes_folder_cubit.dart';

void showFolderEditor(BuildContext context) {
  final folderNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create Folder'),
        content: TextField(
          controller: folderNameController,
          decoration: const InputDecoration(hintText: 'Folder Name'),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    final name = folderNameController.text.trim();
                    if (name.isEmpty) return;
                    final id = UniqueKey().toString();
                    context.read<NotesFolderCubit>().addFolder(
                      NoteFolderEntity(id: id, name: name),
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Create"),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  style: ButtonStyle().copyWith(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
