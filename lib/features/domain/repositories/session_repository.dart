
import 'package:drum_practice_app/features/domain/entities/session_model.dart';

abstract class SessionRepository {
  Future<List<TrainingSession>> getSessions();
  Future<void> saveSessions(List<TrainingSession> sessions);
  
}
