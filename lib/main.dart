import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:marknotes/core/common/entities/app_theme_entity.dart';
import 'package:marknotes/core/router/app_router.dart';
import 'package:marknotes/core/themes/app_themes.dart';
import 'package:marknotes/core/common/bloc/app_theme_cubit/app_theme_cubit.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_data_cubit/notes_data_cubit.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_folder_cubit/notes_folder_cubit.dart';
import 'package:marknotes/init_dependencies.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  // Initialize dependencies
  await initDependencies();
  runApp(const MarkNotesApp());
}

class MarkNotesApp extends StatelessWidget {
  const MarkNotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AppThemeCubit>()),
        BlocProvider(create: (context) => sl<NotesFolderCubit>()),
        BlocProvider(create: (context) => sl<NotesDataCubit>()),
      ],
      child: BlocBuilder<AppThemeCubit, AppThemeEntity>(
        builder: (context, state) {
          return MaterialApp.router(
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: AppThemes().lightTheme,
            darkTheme: AppThemes().darkTheme,
            debugShowCheckedModeBanner: false,
            title: 'MarkNotes',
            routerConfig: AppRouter().router,
          );
        },
      ),
    );
  }
}
