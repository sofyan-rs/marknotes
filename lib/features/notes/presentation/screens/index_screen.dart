import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_app/core/common/entities/app_theme_entity.dart';
import 'package:markdown_app/core/common/enum/tab_enum.dart';
import 'package:markdown_app/core/router/app_router.dart';
import 'package:markdown_app/core/common/bloc/app_theme_cubit/app_theme_cubit.dart';
import 'package:markdown_app/features/notes/presentation/function/show_folder_editor.dart';
import 'package:markdown_app/features/notes/presentation/widgets/folder_list.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:markdown_app/features/notes/presentation/widgets/note_list.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late final TabController _tabController;
  TabState _mode = TabState.all;

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {});
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _mode = _tabController.index == 0 ? TabState.all : TabState.folders;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
        ),
        toolbarHeight: 80,
        centerTitle: false,
        actions: [
          BlocBuilder<AppThemeCubit, AppThemeEntity>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isDarkMode ? LucideIcons.sun : LucideIcons.moon,
                  size: 30,
                ),
                onPressed: () {
                  context.read<AppThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          dividerColor: Colors.transparent,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'All Notes'), Tab(text: 'Folders')],
        ),
      ),
      body:
          _mode == TabState.all
              ? NoteList(searchController: _searchController)
              : FolderList(searchController: _searchController),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_mode == TabState.all) {
            AppRouter().navigate(route: '/note-editor', context: context);
          } else {
            showFolderEditor(context);
          }
        },
        child: Icon(
          _mode == TabState.all ? LucideIcons.plus : LucideIcons.folderPlus,
        ),
      ),
    );
  }
}
