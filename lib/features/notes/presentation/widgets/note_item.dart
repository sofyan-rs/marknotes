import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:markdown_app/core/router/app_router.dart';
import 'package:markdown_app/features/notes/domain/entities/note_entity.dart';
import 'package:markdown_app/features/notes/presentation/function/delete_note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key, required this.note});

  final NoteEntity note;

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
        key: ValueKey(note.id),
        endActionPane: ActionPane(
          motion: BehindMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteNote(context, note);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    note.content.length > 50
                        ? '${note.content.substring(0, 50)}...'
                        : note.content,
                  ),
                  SizedBox(height: 10),
                  Text(
                    DateFormat('dd MMM yyyy • HH:mm').format(note.updatedAt),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    AppRouter().navigate(
                      route: '/note-editor',
                      context: context,
                      extra: {'note': note},
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
