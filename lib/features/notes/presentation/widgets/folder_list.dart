import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:markdown_app/features/notes/domain/entities/note_folder_entity.dart';
import 'package:markdown_app/features/notes/presentation/bloc/notes_folder_cubit/notes_folder_cubit.dart';
import 'package:markdown_app/features/notes/presentation/widgets/folder_item.dart';

class FolderList extends StatefulWidget {
  const FolderList({super.key, required this.searchController});

  final TextEditingController searchController;

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
        BlocBuilder<NotesFolderCubit, List<NoteFolderEntity>>(
          builder: (context, state) {
            List<NoteFolderEntity> filteredFolder = [];
            final search = widget.searchController.text.trim();
            if (search.isEmpty) {
              filteredFolder = state;
            } else {
              final query = search.toLowerCase().trim();
              filteredFolder =
                  state.where((note) {
                    return note.name.toLowerCase().contains(query);
                  }).toList();
            }

            if (filteredFolder.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Icon(
                        LucideIcons.folderOpen,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No folders available',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => FolderItem(folder: filteredFolder[index]),
                childCount: filteredFolder.length, // Example item count
              ),
            );
          },
        ),
      ],
    );
  }
}
