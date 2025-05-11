import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_app/core/router/app_router.dart';
import 'package:markdown_app/features/notes/domain/entities/note_entity.dart';
import 'package:markdown_app/features/notes/presentation/bloc/notes_data_cubit/notes_data_cubit.dart';

void deleteNote(BuildContext context, NoteEntity note) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Delete Note"),
        content: Text("Are you sure want to delete this note?"),
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
                    context.read<NotesDataCubit>().deleteNote(note.id);
                    Navigator.pop(context);
                    AppRouter().navigate(
                      route: '/',
                      context: context,
                      type: NavType.go,
                    );
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
