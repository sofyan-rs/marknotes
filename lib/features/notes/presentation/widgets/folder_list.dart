import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:marknotes/core/common/widgets/empty_placeholder.dart';
import 'package:marknotes/features/notes/domain/entities/note_folder_entity.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_folder_cubit/notes_folder_cubit.dart';
import 'package:marknotes/features/notes/presentation/widgets/folder_item.dart';

class FolderList extends StatefulWidget {
  const FolderList({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  State<FolderList> createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
  List<NoteFolderEntity> folders = [];
  bool isReordering = false;

  @override
  void initState() {
    super.initState();
    folders = context.read<NotesFolderCubit>().state;
    // Listen to the state changes to update the folders list
    context.read<NotesFolderCubit>().stream.listen((state) {
      if (mounted) {
        setState(() {
          folders = state;
        });
      }
    });
  }

  void _onReorder({
    required int oldIndex,
    required int newIndex,
    required NoteFolderEntity folder,
  }) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = folders.removeAt(oldIndex);
      folders.insert(newIndex, item);
    });
    context.read<NotesFolderCubit>().updateFolder(
      folder.id,
      NoteFolderEntity(id: folder.id, name: folder.name, index: newIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Search Folders...',
                    prefixIcon: const Icon(LucideIcons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (folders.length > 1) ...[
                const SizedBox(width: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  label: Icon(
                    isReordering
                        ? LucideIcons.check
                        : LucideIcons.chevronsDownUp,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      isReordering = !isReordering;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<NotesFolderCubit, List<NoteFolderEntity>>(
            builder: (context, state) {
              final query = widget.searchController.text.toLowerCase().trim();
              final filteredFolders =
                  query.isEmpty
                      ? folders
                      : folders
                          .where((f) => f.name.toLowerCase().contains(query))
                          .toList();

              if (filteredFolders.isEmpty) {
                return EmptyPlaceholder(
                  icon: LucideIcons.folderOpen,
                  message: 'No folders found',
                );
              }

              if (isReordering) {
                return ReorderableListView.builder(
                  itemCount: filteredFolders.length,
                  onReorder: (oldIndex, newIndex) {
                    final folder = filteredFolders[oldIndex];
                    _onReorder(
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                      folder: folder,
                    );
                  },
                  padding: const EdgeInsets.only(bottom: 16),
                  proxyDecorator: (child, index, animation) {
                    return child;
                  },
                  itemBuilder: (context, index) {
                    final folder = filteredFolders[index];
                    return KeyedSubtree(
                      key: ValueKey(folder.id),

                      child: FolderItem(
                        folder: folder,
                        isReordering: isReordering,
                      ),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  itemCount: filteredFolders.length,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    final folder = filteredFolders[index];
                    return FolderItem(folder: folder);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
