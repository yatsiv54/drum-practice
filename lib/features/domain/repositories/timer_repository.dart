abstract class TimerRepository {
  Future<void> saveProgress(String planId, double percent);

  Future<double> getProgress(String planId);

  Future<Map<String, double>> getAllProgress();
}
