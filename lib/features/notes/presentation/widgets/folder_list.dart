import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:markdown_app/features/notes/domain/entities/note_entity.dart';
import 'package:markdown_app/features/notes/presentation/bloc/notes_data_cubit/notes_data_cubit.dart';
import 'package:markdown_app/features/notes/presentation/widgets/note_item.dart';

class FolderList extends StatefulWidget {
  FolderList({super.key});

  final searchController = TextEditingController();

  @override
  State<FolderList> createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: widget.searchController,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                hintText: 'Search Folders...',
                prefixIcon: const Icon(LucideIcons.search),
              ),
            ),
          ),
        ),
        BlocBuilder<NotesDataCubit, List<NoteEntity>>(
          builder: (context, state) {
            List<NoteEntity> filteredNote = [];
            final search = widget.searchController.text.trim();
            if (search.isEmpty) {
              filteredNote = state;
            } else {
              final query = search.toLowerCase().trim();
              filteredNote =
                  state.where((note) {
                    return note.title.toLowerCase().contains(query) ||
                        note.content.toLowerCase().contains(query);
                  }).toList();
            }
            filteredNote.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

            if (filteredNote.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Icon(
                        LucideIcons.fileText,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No notes available',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => NoteItem(note: filteredNote[index]),
                childCount: filteredNote.length, // Example item count
              ),
            );
          },
        ),
      ],
    );
  }
}
