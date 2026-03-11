import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:drum_practice_app/features/domain/entities/tag_def.dart';

part 'exercise_details_state.freezed.dart';

@freezed
abstract class ExerciseDetailsState with _$ExerciseDetailsState {
  const factory ExerciseDetailsState.loading() = _Loading;
  const factory ExerciseDetailsState.error(String message) = _Error;
  const factory ExerciseDetailsState.data({
    required Exercise exercise,
    required List<TagDef> allTags,
  }) = _Data;
}
