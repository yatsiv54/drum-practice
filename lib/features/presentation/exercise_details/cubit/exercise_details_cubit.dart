import 'package:bloc/bloc.dart';
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/tag_repository.dart';
import 'exercise_details_state.dart';

class ExerciseDetailsCubit extends Cubit<ExerciseDetailsState> {
  final ExerciseRepository _repo;
  final TagRepository _tagRepo;
  final String id;

  ExerciseDetailsCubit(
    this._repo,
    this._tagRepo,
    this.id, {
    Exercise? initial, 
  }) : super(
         initial != null
             ? ExerciseDetailsState.data(exercise: initial, allTags: const [])
             : const ExerciseDetailsState.loading(),
       ) {
    load(initial: initial);
  }

  Future<void> load({Exercise? initial}) async {
    try {
      
      final Exercise? fromRepo = await _repo.getById(id);
      final Exercise? ex = fromRepo ?? initial;
      if (ex == null) {
        emit(const ExerciseDetailsState.error('Exercise not found'));
        return;
      }
      
      final tags = await _tagRepo.getAll();
      emit(ExerciseDetailsState.data(exercise: ex, allTags: tags));
    } catch (_) {
      emit(const ExerciseDetailsState.error('Failed to load exercise'));
    }
  }

  Future<void> delete() async => _repo.delete(id);
}
