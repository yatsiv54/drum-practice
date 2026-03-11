
import 'package:freezed_annotation/freezed_annotation.dart';
part 'exercise.freezed.dart';
part 'exercise.g.dart';

@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String title,
    required String description,
    required int minutes,                    
    @Default(<String>[]) List<String> tags,
    @Default(<MediaAttachment>[]) List<MediaAttachment> attachments,
    required DateTime createdAt,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}

@freezed
sealed class MediaAttachment with _$MediaAttachment {
  const factory MediaAttachment.image({
    required String path,          
    String? webBase64,             
    String? name,
    int? size,
  }) = ImageAttachment;

  const factory MediaAttachment.pdf({
    required String path,
    String? webBase64,
    String? name,
    int? size,
  }) = PdfAttachment;

  const factory MediaAttachment.video({
    required String path,
    String? webBase64,
    String? name,
    int? size,
  }) = VideoAttachment;

  factory MediaAttachment.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentFromJson(json);
}
