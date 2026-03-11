import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'exercise_list_state.dart';

class ExerciseListCubit extends Cubit<ExerciseListState> {
  final ExerciseRepository repo;
  late final StreamSubscription<List<Exercise>> _sub;

  List<Exercise> _all = const [];
  String _query = '';

  ExerciseListCubit(this.repo) : super(const ExerciseListState.loading()) {
    
    _sub = repo.watchAll().listen(
      (items) {
        _all = items; 
        _apply();
      },
      onError: (e, _) => emit(ExerciseListState.error(e.toString())),
    );
  }

  
  Future<void> load() async {
    emit(const ExerciseListState.loading());
    final items = await repo.getAll();
    _all = items;
    _apply();
  }

  void search(String q) {
    _query = q.trim();
    _apply();
  }

  void _apply() {
    if (_query.isEmpty) {
      emit(ExerciseListState.data(List.unmodifiable(_all)));
      return;
    }

    final q = _query.toLowerCase();

    
    final minutesRegex =
        RegExp(r'^\s*(>=|<=|>|<)?\s*(\d{1,3})\s*(min|mins|minute|minutes|хв|хвилин)?\s*$');
    final m = minutesRegex.firstMatch(q);

    int? minutesVal;
    String? op;
    if (m != null) {
      op = m.group(1);
      minutesVal = int.tryParse(m.group(2) ?? '');
    }

    bool byMinutes(Exercise e) {
      if (minutesVal == null) return false;
      switch (op) {
        case '>=':
          return e.minutes >= minutesVal!;
        case '<=':
          return e.minutes <= minutesVal!;
        case '>':
          return e.minutes > minutesVal!;
        case '<':
          return e.minutes < minutesVal!;
        default:
          return e.minutes == minutesVal!;
      }
    }

    String dateString(DateTime d) {
      const months = [
        'january','february','march','april','may','june',
        'july','august','september','october','november','december',
      ];
      return '${months[d.month - 1]} ${d.day}, ${d.year}';
    }

    final filtered = _all.where((e) {
      final txt =
          '${e.title}\n${e.description}\n${dateString(e.createdAt)}'.toLowerCase();
      final looksLikeMinutes = m != null && (m.group(2)?.isNotEmpty ?? false);
      if (looksLikeMinutes) return byMinutes(e);
      return txt.contains(q) || byMinutes(e);
    }).toList();

    emit(ExerciseListState.data(List.unmodifiable(filtered)));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
