import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drum_practice_app/features/domain/entities/plan.dart';

part 'plans_list_state.freezed.dart';

@freezed
class PlansListState with _$PlansListState {
  const factory PlansListState.loading() = _Loading;
  const factory PlansListState.error(String message) = _Error;
  const factory PlansListState.loaded(List<Plan> plans) = _Loaded;
}
