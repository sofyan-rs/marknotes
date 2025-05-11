import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:marknotes/core/router/app_router.dart';
import 'package:marknotes/features/notes/domain/entities/note_entity.dart';
import 'package:marknotes/features/notes/domain/entities/note_folder_entity.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_data_cubit/notes_data_cubit.dart';
import 'package:marknotes/features/notes/presentation/function/delete_folder.dart';
import 'package:marknotes/features/notes/presentation/function/show_folder_editor.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({
    super.key,
    required this.folder,
    this.isReordering = false,
  });

  final NoteFolderEntity folder;
  final bool isReordering;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Slidable(
        key: ValueKey(folder.id),
        endActionPane: ActionPane(
          motion: BehindMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              onPressed: (context) {
                showFolderEditor(context: context, folder: folder);
              },
              backgroundColor: Theme.of(context).colorScheme.onSurface,
              icon: LucideIcons.penLine,
              label: 'Edit',
              padding: EdgeInsets.all(10),
            ),
            SlidableAction(
              onPressed: (context) {
                deleteFolder(context, folder);
              },
              backgroundColor: Theme.of(context).colorScheme.error,
              icon: LucideIcons.trash,
              label: 'Delete',
              padding: EdgeInsets.all(10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.folderClosed,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          folder.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        BlocBuilder<NotesDataCubit, List<NoteEntity>>(
                          builder: (context, state) {
                            final notes =
                                state
                                    .where((note) => note.folder == folder.id)
                                    .toList();

                            return Text(
                              "${notes.length} notes",
                              style: TextStyle(fontSize: 14),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isReordering) ...[
                    const SizedBox(width: 16),
                    Icon(
                      LucideIcons.gripVertical,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    AppRouter().navigate(
                      route: '/note-folder',
                      context: context,
                      extra: {'folder': folder},
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
