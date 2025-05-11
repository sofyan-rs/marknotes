import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_app/features/notes/presentation/screens/note_editor_screen.dart';
import 'package:markdown_app/features/notes/presentation/screens/index_screen.dart';

enum NavType { push, go }

class AppRouter {
  void navigate({
    required String route,
    required BuildContext context,
    NavType? type,
    Map<String, dynamic>? extra,
  }) {
    if (type == NavType.go) {
      context.go(route, extra: extra);
    } else {
      context.push(route, extra: extra);
    }
  }

  final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        name: 'index',
        path: '/',
        builder: (context, state) => IndexScreen(),
        routes: [
          GoRoute(
            name: 'note-editor',
            path: '/note-editor',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final note = extra?['note'];
              return NoteEditorScreen(note: note);
            },
          ),
        ],
      ),
    ],
  );
}
