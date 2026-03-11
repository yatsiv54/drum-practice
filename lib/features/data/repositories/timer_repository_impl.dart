import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drum_practice_app/features/domain/repositories/timer_repository.dart';

class TimerRepositoryImpl implements TimerRepository {
  static const _kKey = 'timer_progress_v1';

  Future<Map<String, double>> _read() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kKey);
    if (raw == null) return {};
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }

  Future<void> _write(Map<String, double> data) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kKey, jsonEncode(data));
  }

  @override
  Future<double> getProgress(String planId) async {
    final m = await _read();
    return m[planId] ?? 0.0;
  }

  @override
  Future<Map<String, double>> getAllProgress() => _read();

  @override
  Future<void> saveProgress(String planId, double percent) async {
    final m = await _read();
    m[planId] = percent.clamp(0.0, 1.0);
    await _write(m);
  }
}
