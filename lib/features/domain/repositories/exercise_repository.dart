import '../entities/exercise.dart';

abstract class ExerciseRepository {
  Stream<List<Exercise>> watchAll();

  Future<List<Exercise>> getAll();

  Future<Exercise?> getById(String id);
  Future<void> upsert(Exercise e);
  Future<void> delete(String id);
  Future<void> deleteAll();
  
  
}
