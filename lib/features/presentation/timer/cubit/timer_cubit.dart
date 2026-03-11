import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:drum_practice_app/features/domain/entities/plan.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/plan_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/timer_repository.dart';
import 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final PlanRepository plans;
  final ExerciseRepository exercises;
  final TimerRepository progressRepo;

  Timer? _ticker;
  StreamSubscription<List<Plan>>? _plansSub;
  Timer? _debounce;

  TimerCubit(this.plans, this.exercises, this.progressRepo)
    : super(const TimerState.idle(items: []));

  Future<void> watch() async {
    unawaited(_refreshOnce());
    await _plansSub?.cancel();
    _plansSub = plans.watchAll().listen((_) {
      final running = state.maybeWhen(
        running: (_, __, ___, ____, _____) => true,
        orElse: () => false,
      );
      if (running) return;
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 120), () {
        Future.microtask(_refreshOnce);
      });
    });
  }

  Future<void> _refreshOnce() async {
    try {
      final all = await plans.getAll().timeout(const Duration(seconds: 1));
      final prog = await progressRepo.getAllProgress().timeout(
        const Duration(seconds: 1),
      );
      final items = <TimerPlanItem>[
        for (final p in all)
          TimerPlanItem(p, (prog[p.id] ?? 0.0).clamp(0.0, 1.0)),
      ];
      state.maybeWhen(
        running: (_, __, ___, ____, _____) {},
        orElse: () => emit(TimerState.idle(items: items)),
      );
    } catch (_) {
      /* ignore */
    }
  }

  Future<void> start(String planId) async {
    _stopTicker();
    try {
      final plan = await plans
          .getById(planId)
          .timeout(const Duration(seconds: 1));
      if (plan == null || plan.items.isEmpty) {
        await _refreshOnce();
        return;
      }
      var saved = await progressRepo
          .getProgress(planId)
          .timeout(const Duration(milliseconds: 600));
      if (saved >= 0.9999) saved = 0.0;
      final pos = await _startPosFor(plan, saved);
      emit(
        TimerState.running(
          plan: plan,
          index: pos.index,
          secsLeft: pos.secsLeft,
          secsTotal: pos.secsTotal,
          paused: false,
        ),
      );
      _startTicker();
    } catch (_) {
      await _refreshOnce();
    }
  }

  void pause() {
    _stopTicker();
    state.maybeWhen(
      running: (plan, i, l, t, _) => emit(
        TimerState.running(
          plan: plan,
          index: i,
          secsLeft: l,
          secsTotal: t,
          paused: true,
        ),
      ),
      orElse: () {},
    );
  }

  void resume() {
    state.maybeWhen(
      running: (plan, i, l, t, paused) {
        if (!paused) return;
        emit(
          TimerState.running(
            plan: plan,
            index: i,
            secsLeft: l,
            secsTotal: t,
            paused: false,
          ),
        );
        _startTicker();
      },
      orElse: () {},
    );
  }

  void resetCurrent() {
    state.maybeWhen(
      running: (plan, i, l, t, paused) => emit(
        TimerState.running(
          plan: plan,
          index: i,
          secsLeft: t,
          secsTotal: t,
          paused: paused,
        ),
      ),
      orElse: () {},
    );
  }

  /// ВАЖЛИВО: завжди завершує RUNNING, зберігає прогрес і повертає у idle зі свіжим списком.
  Future<void> saveAndExit() async {
    try {
      await state.maybeWhen(
        running: (plan, i, l, t, _) async {
          final percent = await _percentFor(plan, i, l, t);
          await progressRepo.saveProgress(plan.id, percent);
          final all = await plans.getAll().timeout(const Duration(seconds: 1));
          final prog = await progressRepo.getAllProgress().timeout(
            const Duration(seconds: 1),
          );
          final items = <TimerPlanItem>[
            for (final p in all)
              TimerPlanItem(p, (prog[p.id] ?? 0.0).clamp(0.0, 1.0)),
          ];

          emit(TimerState.idle(items: items));
        },
        orElse: () async {},
      );
    } catch (_) {
      /* ignore */
    }
    _stopTicker();
    await _refreshOnce(); // це переведе в idle зі свіжими даними
  }

  Future<void> saveCurrentProgress() async {
    try {
      await state.maybeWhen(
        running: (plan, i, l, t, _) async {
          final percent = await _percentFor(plan, i, l, t);
          await progressRepo.saveProgress(plan.id, percent);
        },
        orElse: () async {},
      );
    } catch (_) {
      /* ignore */
    }
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  Future<void> _tick() async {
    await state.maybeWhen(
      running: (plan, index, secsLeft, secsTotal, paused) async {
        if (paused) return;

        final left = secsLeft - 1;
        if (left > 0) {
          emit(
            TimerState.running(
              plan: plan,
              index: index,
              secsLeft: left,
              secsTotal: secsTotal,
              paused: false,
            ),
          );
          return;
        }

        try {
          final percent = await _percentFor(plan, index, 0, secsTotal);
          await progressRepo.saveProgress(plan.id, percent);
        } catch (_) {}

        final next = index + 1;
        if (next >= plan.items.length) {
          try {
            await progressRepo.saveProgress(plan.id, 1.0);
          } catch (_) {}
          _stopTicker();
          await _refreshOnce();
          return;
        }

        final nextSecs = await _secsOfItem(plan.items[next]);
        emit(
          TimerState.running(
            plan: plan,
            index: next,
            secsLeft: nextSecs,
            secsTotal: nextSecs,
            paused: false,
          ),
        );
      },
      orElse: () async {},
    );
  }

  Future<int> _secsOfItem(PlanItem it) async {
    try {
      if (it.minutes > 0) return it.minutes * 60;
      final ex = await exercises
          .getById(it.exerciseId)
          .timeout(const Duration(seconds: 1));
      final mm = (ex?.minutes ?? 0);
      return (mm > 0 ? mm : 0) * 60;
    } catch (_) {
      return 0;
    }
  }

  Future<int> _totalSecs(Plan plan) async {
    var total = 0;
    for (final it in plan.items) {
      total += await _secsOfItem(it);
    }
    return total;
  }

  Future<double> _percentFor(
    Plan plan,
    int index,
    int secsLeft,
    int secsTotal,
  ) async {
    final total = await _totalSecs(plan);
    if (total == 0) return 0.0;
    var done = 0;
    for (int i = 0; i < plan.items.length; i++) {
      final cur = await _secsOfItem(plan.items[i]);
      if (i < index) {
        done += cur;
      } else if (i == index) {
        final passed = cur - secsLeft;
        done += passed.clamp(0, cur);
      }
    }
    return done / total;
  }

  Future<_StartPos> _startPosFor(Plan plan, double percent) async {
    final secs = <int>[];
    for (final it in plan.items) {
      secs.add(await _secsOfItem(it));
    }
    final total = secs.fold<int>(0, (a, b) => a + b);
    if (total == 0) return _StartPos(0, 60, 60);

    final elapsed = (percent.clamp(0.0, 0.9999) * total).floor();
    var acc = 0;
    for (int i = 0; i < secs.length; i++) {
      final nextAcc = acc + secs[i];
      if (elapsed < nextAcc) {
        final offset = elapsed - acc;
        final left = secs[i] - offset;
        return _StartPos(i, left, secs[i]);
      }
      acc = nextAcc;
    }
    final first = secs.isNotEmpty ? secs.first : 60;
    return _StartPos(0, first, first);
  }

  @override
  Future<void> close() async {
    _stopTicker();
    await _plansSub?.cancel();
    _debounce?.cancel();
    return super.close();
  }
}

class _StartPos {
  final int index;
  final int secsLeft;
  final int secsTotal;
  _StartPos(this.index, this.secsLeft, this.secsTotal);
}
