import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:intl/intl.dart';
import 'package:marknotes/core/common/bloc/app_theme_cubit/app_theme_cubit.dart';
import 'package:marknotes/core/common/entities/app_theme_entity.dart';
import 'package:marknotes/core/themes/app_colors.dart';
import 'package:marknotes/core/utils/open_link.dart';
import 'package:marknotes/features/notes/domain/entities/note_entity.dart';

class NoteViewerMode extends StatelessWidget {
  const NoteViewerMode({super.key, required this.note});

  final NoteEntity note;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeEntity>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color:
                state.isDarkMode
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
          ),
          child: Markdown(
            padding: EdgeInsets.all(16.0),
            data:
                '# ${note.title}\n\n${DateFormat('dd MMM yyyy • HH:mm').format(note.updatedAt)}\n\n${note.content}',
            styleSheet: MarkdownStyleSheet(
              h1: TextStyle(fontSize: 24),
              blockquoteDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            selectable: true,
            onTapLink: (text, href, title) async {
              if (href != null) {
                await openLink(href);
              }
            },
          ),
        );
      },
    );
  }
}
