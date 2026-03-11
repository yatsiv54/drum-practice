
import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../domain/entities/exercise.dart';
import '../../../domain/repositories/exercise_repository.dart';
import 'home_exercises_state.dart';

class HomeExercisesCubit extends Cubit<HomeExercisesState> {
  final ExerciseRepository _repo;
  late final StreamSubscription<List<Exercise>> _sub;

  List<Exercise> _items = const [];

  HomeExercisesCubit(this._repo) : super(const HomeExercisesState.loading()) {
    
    _sub = _repo.watchAll().listen(
      (list) {
        _items = list;
        emit(HomeExercisesState.data(items: List.unmodifiable(_items)));
      },
      onError: (e, _) => emit(HomeExercisesState.error(e.toString())),
    );
  }

  
  Future<void> refresh() async {
    emit(const HomeExercisesState.loading());
    final list = await _repo.getAll();
    _items = list;
    emit(HomeExercisesState.data(items: List.unmodifiable(_items)));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
