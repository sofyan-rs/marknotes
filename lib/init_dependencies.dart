import 'package:get_it/get_it.dart';
import 'package:marknotes/core/common/bloc/app_theme_cubit/app_theme_cubit.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_data_cubit/notes_data_cubit.dart';
import 'package:marknotes/features/notes/presentation/bloc/notes_folder_cubit/notes_folder_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  _initThemes();
  _initNotes();
}

void _initThemes() {
  sl.registerLazySingleton(() => AppThemeCubit());
}

void _initNotes() {
  sl.registerLazySingleton(() => NotesDataCubit());
  sl.registerLazySingleton(() => NotesFolderCubit());
}
