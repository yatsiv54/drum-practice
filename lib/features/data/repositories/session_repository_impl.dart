

import 'dart:convert';
import 'package:drum_practice_app/features/domain/entities/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  static const _key = 'training_sessions';

  
  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  @override
  Future<List<TrainingSession>> getSessions() async {
    final prefs = await _prefs;                
    final raw = prefs.getStringList(_key) ?? [];
    final sessions = raw
        .map((e) => TrainingSession.fromJson(json.decode(e)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }

  @override
  Future<void> saveSessions(List<TrainingSession> sessions) async {
    final prefs = await _prefs;                
    final encoded = sessions.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }
}
