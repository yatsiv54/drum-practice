import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import 'package:drum_practice_app/features/domain/entities/plan.dart';
import 'package:drum_practice_app/features/domain/repositories/plan_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'plan_editor_state.dart';

class PlanEditorCubit extends Cubit<PlanEditorState> {
  final PlanRepository planRepo;
  final ExerciseRepository exRepo;

  PlanEditorCubit(this.planRepo, this.exRepo) : super(const PlanEditorState());

  void setTitle(String v) => emit(state.copyWith(title: v, saved: false));

  Future<void> loadForEdit(String id) async {
    final p = await planRepo.getById(id);
    if (p == null) {
      emit(state.copyWith(error: 'Plan not found'));
      return;
    }
    emit(
      state.copyWith(
        id: p.id,
        title: p.title,
        exerciseIds: p.items.map((e) => e.exerciseId).toList(),
        saved: false,
        error: null,
      ),
    );
  }

  void setExercises(List<String> ids) =>
      emit(state.copyWith(exerciseIds: ids, saved: false));

  Future<void> save() async {
    if (state.title.trim().isEmpty) {
      emit(state.copyWith(error: 'Title is required'));
      return;
    }
    if (state.exerciseIds.isEmpty) {
      emit(state.copyWith(error: 'Select at least one exercise'));
      return;
    }
    emit(state.copyWith(saving: true, error: null));

    final exercises = await exRepo.getAll();
    final items = <PlanItem>[];
    for (final id in state.exerciseIds) {
      final ex = exercises.firstWhereOrNull((e) => e.id == id);
      if (ex != null) {
        items.add(PlanItem(exerciseId: ex.id, minutes: ex.minutes));
      }
    }

    final plan = Plan(
      id: state.id ?? const Uuid().v4(),
      title: state.title.trim(),
      items: items,
      createdAt: DateTime.now(),
    );
    await planRepo.upsert(plan);
    emit(state.copyWith(saving: false, saved: true));
  }
}
