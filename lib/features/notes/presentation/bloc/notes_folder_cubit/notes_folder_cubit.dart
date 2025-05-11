import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:markdown_app/features/notes/domain/entities/note_folder_entity.dart';

class NotesFolderCubit extends HydratedCubit<List<NoteFolderEntity>> {
  NotesFolderCubit() : super([]);

  void addFolder(NoteFolderEntity folder) {
    final updatedFolders = List<NoteFolderEntity>.from(state);
    updatedFolders.add(folder);
    emit(updatedFolders);
  }

  void deleteFolder(String folderId) {
    final updatedFolders = List<NoteFolderEntity>.from(state);
    updatedFolders.removeWhere((folder) => folder.id == folderId);
    emit(updatedFolders);
  }

  void updateFolder(NoteFolderEntity oldFolder, NoteFolderEntity newFolder) {
    final updatedFolders = List<NoteFolderEntity>.from(state);
    final index = updatedFolders.indexOf(oldFolder);
    if (index != -1) {
      updatedFolders[index] = newFolder;
      emit(updatedFolders);
    }
  }

  @override
  List<NoteFolderEntity>? fromJson(Map<String, dynamic> json) {
    if (json['folders'] != null) {
      return (json['folders'] as List)
          .map((folder) => NoteFolderEntity.fromJson(folder))
          .toList();
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(List<NoteFolderEntity> state) {
    return {'folders': state.map((folder) => folder.toJson()).toList()};
  }
}
