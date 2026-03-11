import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/exercise.dart';

part 'home_exercises_state.freezed.dart';

@freezed
class HomeExercisesState with _$HomeExercisesState {
  const factory HomeExercisesState.loading() = _Loading;
  const factory HomeExercisesState.error(String message) = _Error;
  const factory HomeExercisesState.data({
    required List<Exercise> items,
  }) = _Data;
}
