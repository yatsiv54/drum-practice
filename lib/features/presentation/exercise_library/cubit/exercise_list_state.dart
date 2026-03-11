
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_list_state.freezed.dart';

@freezed
abstract class ExerciseListState with _$ExerciseListState {
  const factory ExerciseListState.loading() = _Loading;
  const factory ExerciseListState.data(List<Exercise> items) = _Data;
  const factory ExerciseListState.error(String message) = _Error;
}
