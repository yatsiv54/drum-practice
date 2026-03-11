import 'package:bloc/bloc.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/plan_repository.dart';
import 'plan_details_state.dart';

class PlanDetailsCubit extends Cubit<PlanDetailsState> {
  final PlanRepository _plans;
  final ExerciseRepository _exercises;

  PlanDetailsCubit(this._plans, this._exercises)
      : super(const PlanDetailsState.loading());

  Future<void> load(String planId) async {
    emit(const PlanDetailsState.loading());
    try {
      final plan = await _plans.getById(planId);
      if (plan == null) {
        emit(const PlanDetailsState.error('Plan not found'));
        return;
      }

      
      final all = await _exercises.getAll();
      final byId = {for (final e in all) e.id: e};

      final rows = <PlanRow>[];
      var total = 0;

      for (final item in plan.items) {
        final ex = byId[item.exerciseId];
        final title = ex?.title ?? 'Unknown';
        
        final minutes = (item.minutes != null)
            ? item.minutes!.round()
            : (ex?.minutes ?? 0).round();

        rows.add(PlanRow(title, minutes));
        total += minutes;
      }

      emit(PlanDetailsState.loaded(
        planId: plan.id,
        title: plan.title,
        totalMinutes: total,
        rows: rows,
      ));
    } catch (e) {
      emit(const PlanDetailsState.error('Failed to load plan'));
    }
  }

  Future<void> refresh() async {
    final s = state;
    s.maybeWhen(
      loaded: (id, _, __, ___) => load(id),
      orElse: () {},
    );
  }
}
