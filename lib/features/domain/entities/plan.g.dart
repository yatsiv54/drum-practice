// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanItem _$PlanItemFromJson(Map<String, dynamic> json) => _PlanItem(
  exerciseId: json['exerciseId'] as String,
  minutes: (json['minutes'] as num).toInt(),
);

Map<String, dynamic> _$PlanItemToJson(_PlanItem instance) => <String, dynamic>{
  'exerciseId': instance.exerciseId,
  'minutes': instance.minutes,
};

_Plan _$PlanFromJson(Map<String, dynamic> json) => _Plan(
  id: json['id'] as String,
  title: json['title'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => PlanItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PlanToJson(_Plan instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'items': instance.items,
  'createdAt': instance.createdAt.toIso8601String(),
};
