import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan.freezed.dart';
part 'plan.g.dart';

@freezed
abstract class PlanItem with _$PlanItem {
  const factory PlanItem({
    required String exerciseId,
    required int minutes, 
  }) = _PlanItem;

  factory PlanItem.fromJson(Map<String, dynamic> json) => _$PlanItemFromJson(json);
}

@freezed
abstract class Plan with _$Plan {
  const factory Plan({
    required String id,
    required String title,
    required List<PlanItem> items,       
    required DateTime createdAt,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}
