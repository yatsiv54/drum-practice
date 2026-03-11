import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:drum_practice_app/features/domain/entities/tag_def.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/tag_repository.dart';

import 'exercise_editor_state.dart';

class ExerciseEditorCubit extends Cubit<ExerciseEditorState> {
  final ExerciseRepository repo;
  final TagRepository tagRepo;

  ExerciseEditorCubit(this.repo, this.tagRepo, {String? editId})
      : super(
          const ExerciseEditorState.editing(
            title: '',
            description: '',
            minutes: 5,
            loading: false,
          ),
        ) {
    _loadTags();
    if (editId != null) _load(editId);
  }

  Future<void> _loadTags() async {
    final all = await tagRepo.getAll();
    emit(state.copyWith(availableTags: all));
  }

  Future<void> _load(String id) async {
    emit(state.copyWith(loading: true));
    final e = await repo.getById(id);
    if (e != null) {
      emit(
        ExerciseEditorState.editing(
          id: e.id,
          title: e.title,
          description: e.description,
          minutes: e.minutes,
          tags: e.tags,
          attachments: e.attachments,
          availableTags: state.availableTags,
        ),
      );
    } else {
      emit(state.copyWith(error: 'Exercise not found', loading: false));
    }
  }

  // UI setters
  void setTitle(String v) =>
      emit(state.copyWith(title: v, saved: false, error: null));

  void setDescription(String v) =>
      emit(state.copyWith(description: v, saved: false, error: null));

  void setMinutes(int v) =>
      emit(state.copyWith(minutes: v, saved: false, error: null));

  void addTag(String tag) {
    final norm = tag.trim();
    if (norm.isEmpty || state.tags.contains(norm)) return;
    emit(state.copyWith(tags: [...state.tags, norm], saved: false));
  }

  void removeTag(String tag) {
    final updated = [...state.tags]..remove(tag);
    emit(state.copyWith(tags: updated, saved: false));
  }

  void addAttachment(MediaAttachment a) =>
      emit(state.copyWith(attachments: [...state.attachments, a], saved: false));

  void removeAttachment(int index) {
    final updated = [...state.attachments]..removeAt(index);
    emit(state.copyWith(attachments: updated, saved: false));
  }

  // Save exercise
  Future<void> save() async {
    if (state.title.trim().isEmpty) {
      emit(state.copyWith(error: 'Title is required'));
      return;
    }

    final ex = Exercise(
      id: state.id ?? const Uuid().v4(),
      title: state.title.trim(),
      description: state.description.trim(),
      minutes: state.minutes,
      tags: state.tags,
      attachments: state.attachments,
      createdAt: DateTime.now(),
    );

    await repo.upsert(ex);
    emit(state.copyWith(saved: true));
  }

  // Saved tags
  Future<void> saveNewTag(String name, int colorValue) async {
    final norm = name.trim();
    if (norm.isEmpty) return;

    final alreadyExists = state.availableTags.any(
      (t) => t.name.toLowerCase() == norm.toLowerCase(),
    );
    if (alreadyExists) return;

    final def = TagDef(name: norm, color: colorValue);
    await tagRepo.upsert(def);

    final updated = [...state.availableTags, def]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    emit(state.copyWith(availableTags: updated));
  }

  Future<void> deleteSavedTag(String name) async {
    final norm = name.trim().toLowerCase();
    await tagRepo.delete(norm);

    final updatedCatalog = [...state.availableTags]
      ..removeWhere((t) => t.name.toLowerCase() == norm);

    final updatedTags = [...state.tags]
      ..removeWhere((t) => t.toLowerCase() == norm);

    emit(state.copyWith(availableTags: updatedCatalog, tags: updatedTags));
  }
}
