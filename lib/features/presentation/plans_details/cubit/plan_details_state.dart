import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_details_state.freezed.dart';

@freezed
class PlanDetailsState with _$PlanDetailsState {
  const factory PlanDetailsState.loading() = _Loading;
  const factory PlanDetailsState.error(String message) = _Error;

  
  const factory PlanDetailsState.loaded({
    required String planId,
    required String title,
    required int totalMinutes,
    required List<PlanRow> rows,
  }) = _Loaded;
}

@immutable
class PlanRow {
  final String title;
  final int minutes;
  const PlanRow(this.title, this.minutes);
}
