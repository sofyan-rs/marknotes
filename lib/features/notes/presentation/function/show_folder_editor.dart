import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marknotes/features/notes/domain/entities/note_folder_entity.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_folder_cubit/notes_folder_cubit.dart';

void showFolderEditor({
  required BuildContext context,
  NoteFolderEntity? folder,
}) {
  final formKey = GlobalKey<FormState>();
  final folderNameController = TextEditingController();

  if (folder != null) {
    folderNameController.text = folder.name;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(folder == null ? 'Create Folder' : 'Edit Folder'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: folderNameController,
            decoration: const InputDecoration(hintText: 'Folder Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a folder name';
              }
              return null;
            },
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() != true) return;
                    final name = folderNameController.text.trim();
                    if (name.isEmpty) return;
                    final id = UniqueKey().toString();
                    final index = context.read<NotesFolderCubit>().state.length;
                    if (folder == null) {
                      context.read<NotesFolderCubit>().addFolder(
                        NoteFolderEntity(id: id, name: name, index: index),
                      );
                    } else {
                      context.read<NotesFolderCubit>().updateFolder(
                        folder.id,
                        NoteFolderEntity(
                          id: folder.id,
                          name: name,
                          index: folder.index,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text(folder == null ? 'Create' : 'Update'),
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
