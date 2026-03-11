// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrainingSession _$TrainingSessionFromJson(Map<String, dynamic> json) =>
    _TrainingSession(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$TrainingSessionToJson(_TrainingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
    };
