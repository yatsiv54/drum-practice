import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_editor_state.freezed.dart';

@freezed
abstract class PlanEditorState with _$PlanEditorState {
  const factory PlanEditorState({
    String? id,
    @Default('') String title,
    @Default([]) List<String> exerciseIds,
    @Default(false) bool saving,
    @Default(false) bool saved,
    String? error,
  }) = _PlanEditorState;
}
