import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marknotes/features/notes/domain/entities/note_folder_entity.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_data_cubit/notes_data_cubit.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_folder_cubit/notes_folder_cubit.dart';

void deleteFolder(BuildContext context, NoteFolderEntity folder) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Delete Note"),
        content: Text("Are you sure want to delete this folder?"),
        actions: [
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: ButtonStyle().copyWith(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: () {
                    context.read<NotesFolderCubit>().deleteFolder(folder.id);
                    context.read<NotesDataCubit>().deleteFolderInNotes(
                      folder.id,
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Yes"),
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
                  child: Text("No"),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
