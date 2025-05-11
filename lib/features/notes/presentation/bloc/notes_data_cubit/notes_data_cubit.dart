import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:markdown_app/features/notes/domain/entities/note_entity.dart';

class NotesDataCubit extends HydratedCubit<List<NoteEntity>> {
  NotesDataCubit() : super([]);

  void addNote(NoteEntity note) {
    final updatedNotes = [...state, note];
    emit(updatedNotes);
  }

  void updateNote(NoteEntity note) {
    final updatedNotes = state.map((n) => n.id == note.id ? note : n).toList();
    emit(updatedNotes);
  }

  void deleteNote(String noteId) {
    final updatedNotes = state.where((note) => note.id != noteId).toList();
    emit(updatedNotes);
  }

  @override
  List<NoteEntity>? fromJson(Map<String, dynamic> json) {
    try {
      final notes =
          (json['notes'] as List).map((e) => NoteEntity.fromJson(e)).toList();
      return notes;
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(List<NoteEntity> state) {
    try {
      return {'notes': state.map((note) => note.toJson()).toList()};
    } catch (e) {
      return null;
    }
  }
}
