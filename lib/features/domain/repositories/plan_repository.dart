import 'package:drum_practice_app/features/domain/entities/plan.dart';

abstract class PlanRepository {
  Future<List<Plan>> getAll();
  Future<Plan?> getById(String id);
  Future<void> upsert(Plan plan);
  Future<void> delete(String id);
  Stream<List<Plan>> watchAll();
  Future<void> deleteAll();
}
