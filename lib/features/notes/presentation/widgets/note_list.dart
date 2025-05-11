import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:marknotes/features/notes/domain/entities/note_entity.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_data_cubit/notes_data_cubit.dart';
import 'package:marknotes/features/notes/presentation/widgets/note_item.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key, required this.searchController, this.folderId});

  final TextEditingController searchController;
  final String? folderId;

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
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
                hintText: 'Search Notes...',
                prefixIcon: const Icon(LucideIcons.search),
              ),
            ),
          ),
        ),
        BlocBuilder<NotesDataCubit, List<NoteEntity>>(
          builder: (context, state) {
            List<NoteEntity> filteredNote = [];
            if (widget.folderId != null) {
              state =
                  state
                      .where((note) => note.folder == widget.folderId)
                      .toList();
            }

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
                (context, index) => NoteItem(
                  note: filteredNote[index],
                  isInIndex: widget.folderId != null,
                ),
                childCount: filteredNote.length, // Example item count
              ),
            );
          },
        ),
      ],
    );
  }
}
