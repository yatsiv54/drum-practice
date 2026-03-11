// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  minutes: (json['minutes'] as num).toInt(),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MediaAttachment>[],
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'minutes': instance.minutes,
  'tags': instance.tags,
  'attachments': instance.attachments,
  'createdAt': instance.createdAt.toIso8601String(),
};

ImageAttachment _$ImageAttachmentFromJson(Map<String, dynamic> json) =>
    ImageAttachment(
      path: json['path'] as String,
      webBase64: json['webBase64'] as String?,
      name: json['name'] as String?,
      size: (json['size'] as num?)?.toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ImageAttachmentToJson(ImageAttachment instance) =>
    <String, dynamic>{
      'path': instance.path,
      'webBase64': instance.webBase64,
      'name': instance.name,
      'size': instance.size,
      'runtimeType': instance.$type,
    };

PdfAttachment _$PdfAttachmentFromJson(Map<String, dynamic> json) =>
    PdfAttachment(
      path: json['path'] as String,
      webBase64: json['webBase64'] as String?,
      name: json['name'] as String?,
      size: (json['size'] as num?)?.toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$PdfAttachmentToJson(PdfAttachment instance) =>
    <String, dynamic>{
      'path': instance.path,
      'webBase64': instance.webBase64,
      'name': instance.name,
      'size': instance.size,
      'runtimeType': instance.$type,
    };

VideoAttachment _$VideoAttachmentFromJson(Map<String, dynamic> json) =>
    VideoAttachment(
      path: json['path'] as String,
      webBase64: json['webBase64'] as String?,
      name: json['name'] as String?,
      size: (json['size'] as num?)?.toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$VideoAttachmentToJson(VideoAttachment instance) =>
    <String, dynamic>{
      'path': instance.path,
      'webBase64': instance.webBase64,
      'name': instance.name,
      'size': instance.size,
      'runtimeType': instance.$type,
    };
