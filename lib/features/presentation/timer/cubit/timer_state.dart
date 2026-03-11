import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drum_practice_app/features/domain/entities/plan.dart';

part 'timer_state.freezed.dart';

@freezed
abstract class TimerState with _$TimerState {
  const factory TimerState.loading() = _Loading;
  const factory TimerState.idle({required List<TimerPlanItem> items}) = _Idle;
  const factory TimerState.running({
    required Plan plan,
    required int index,
    required int secsLeft,
    required int secsTotal,
    required bool paused,
  }) = _Running;
}

class TimerPlanItem {
  final Plan plan;
  final double progress; 
  const TimerPlanItem(this.plan, this.progress);
}

