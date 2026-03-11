// lib/features/library/presentation/cubit/exercise_editor_state.dart
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:drum_practice_app/features/domain/entities/tag_def.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'exercise_editor_state.freezed.dart';

@freezed
abstract class ExerciseEditorState with _$ExerciseEditorState {
  const factory ExerciseEditorState.editing({
    String? id,
    required String title,
    required String description,
    required int minutes,
    @Default(<String>[]) List<String> tags,                // імена тегів на вправі
    @Default(<MediaAttachment>[]) List<MediaAttachment> attachments,
    @Default(<TagDef>[]) List<TagDef> availableTags,       // каталог збережених тегів
    String? error,
    bool? saved,
    bool? loading,
  }) = _Editing;
}
