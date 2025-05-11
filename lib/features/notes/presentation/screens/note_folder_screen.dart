import 'package:flutter/material.dart';
import 'package:marknotes/core/router/app_router.dart';
import 'package:marknotes/features/notes/domain/entities/note_folder_entity.dart';
import 'package:marknotes/features/notes/presentation/widgets/note_list.dart';

class NoteFolderScreen extends StatefulWidget {
  const NoteFolderScreen({super.key, required this.folder});

  final NoteFolderEntity folder;

  @override
  State<NoteFolderScreen> createState() => _NoteFolderScreenState();
}

class _NoteFolderScreenState extends State<NoteFolderScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.folder.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        toolbarHeight: 80,
        centerTitle: false,
      ),
      body: NoteList(
        searchController: _searchController,
        folderId: widget.folder.id,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter().navigate(
            route: '/note-editor',
            context: context,
            extra: {'folderId': widget.folder.id},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
