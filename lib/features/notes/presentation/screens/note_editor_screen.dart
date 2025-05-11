import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:marknotes/core/common/widgets/empty_placeholder.dart';
import 'package:marknotes/core/router/app_router.dart';
import 'package:marknotes/features/notes/domain/entities/note_entity.dart';
import 'package:marknotes/features/notes/domain/entities/note_folder_entity.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_data_cubit/notes_data_cubit.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_folder_cubit/notes_folder_cubit.dart';
import 'package:marknotes/features/notes/presentation/function/delete_note.dart';
import 'package:marknotes/features/notes/presentation/widgets/note_editor_mode.dart';
import 'package:marknotes/features/notes/presentation/widgets/note_viewer_mode.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note, this.folderId});

  final NoteEntity? note;
  final String? folderId;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  bool _editMode = true;
  String? _selectedFolder;

  void _saveNote() {
    if (formKey.currentState?.validate() == false) return;

    final title = _titleController.text.trim();
    final content = _noteController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    final now = DateTime.now();

    if (widget.note != null) {
      final id = widget.note!.id;
      final note = NoteEntity(
        id: id,
        title: title,
        content: content,
        createdAt: widget.note!.createdAt,
        updatedAt: now,
        folder: _selectedFolder,
      );
      context.read<NotesDataCubit>().updateNote(note);
      AppRouter().navigate(
        route: '/note-editor',
        context: context,
        extra: {'note': note},
        type: NavType.replace,
      );
    } else {
      final id = UniqueKey().toString();
      final note = NoteEntity(
        id: id,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
        folder: _selectedFolder,
      );
      context.read<NotesDataCubit>().addNote(note);
      AppRouter().navigate(
        route: '/note-editor',
        context: context,
        extra: {'note': note},
        type: NavType.replace,
      );
    }
    setState(() {
      _editMode = false;
    });
  }

  void _selectFolder() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return BlocBuilder<NotesFolderCubit, List<NoteFolderEntity>>(
          builder: (context, state) {
            if (state.isEmpty) {
              return EmptyPlaceholder(
                icon: LucideIcons.folderOpen,
                message: 'No folders found',
              );
            }

            return ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) {
                final folder = state[index];
                return ListTile(
                  leading: Icon(
                    LucideIcons.folder,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(folder.name),
                  onTap: () {
                    setState(() {
                      if (_selectedFolder == folder.id) {
                        _selectedFolder = null;
                      } else {
                        _selectedFolder = folder.id;
                      }
                    });
                    Navigator.pop(context);
                  },
                  trailing: Icon(
                    _selectedFolder == folder.id
                        ? LucideIcons.squareCheck
                        : null,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    if (widget.note != null) {
      _editMode = false;
      _titleController.text = widget.note!.title;
      _noteController.text = widget.note!.content;
      _selectedFolder = widget.note!.folder;
    }
    if (widget.folderId != null) {
      _selectedFolder = widget.folderId;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          if (!_editMode)
            IconButton(
              icon: const Icon(LucideIcons.penLine),
              onPressed: () {
                setState(() {
                  _editMode = true;
                });
              },
            ),
          if (_editMode) ...[
            IconButton(
              icon: const Icon(LucideIcons.folder),
              onPressed: _selectFolder,
            ),
            IconButton(
              icon: const Icon(LucideIcons.save),
              onPressed: _saveNote,
            ),
          ],
          if (widget.note != null)
            IconButton(
              icon: const Icon(LucideIcons.trash, color: Colors.red),
              onPressed: () {
                deleteNote(context: context, note: widget.note!);
              },
            ),
          SizedBox(width: 10),
        ],
      ),
      body:
          !_editMode
              ? NoteViewerMode(note: widget.note!)
              : NoteEditorMode(
                formKey: formKey,
                titleController: _titleController,
                noteController: _noteController,
              ),
    );
  }
}
