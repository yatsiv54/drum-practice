// lib/features/presentation/plans/cubit/plans_list_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drum_practice_app/features/domain/entities/plan.dart';
import 'package:drum_practice_app/features/domain/repositories/plan_repository.dart';
import 'plans_list_state.dart';

class PlansListCubit extends Cubit<PlansListState> {
  final PlanRepository repo;
  StreamSubscription<List<Plan>>? _sub;

  PlansListCubit(this.repo) : super(const PlansListState.loading());

  // живе слухання
  Future<void> watch() async {
    emit(const PlansListState.loading());
    await _sub?.cancel();
    _sub = repo.watchAll().listen(
      (items) => emit(PlansListState.loaded(items)),
      onError: (e) => emit(PlansListState.error(e.toString())),
    );
  }

  // одноразове завантаження (якщо десь треба)
  Future<void> loadOnce() async {
    emit(const PlansListState.loading());
    try {
      final items = await repo.getAll();
      emit(PlansListState.loaded(items));
    } catch (e) {
      emit(PlansListState.error(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
