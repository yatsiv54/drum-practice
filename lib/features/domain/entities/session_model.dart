import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class TrainingSession with _$TrainingSession {
  const factory TrainingSession({
    required String id,
    required String title,
    required DateTime date,
    required int durationMinutes,
  }) = _TrainingSession;

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionFromJson(json);
}
