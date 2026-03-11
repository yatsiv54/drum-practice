import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  static const _key = 'exercises';
  final _controller = StreamController<List<Exercise>>.broadcast();
  List<Exercise> _cache = [];

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  ExerciseRepositoryImpl() {
    _load();
  }
  @override
  Future<void> deleteAll() async {
    _cache = [];
    await _save(); 
    _emit(); 
  }

  Future<void> _load() async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_key) ?? [];
    _cache = raw.map((e) => Exercise.fromJson(json.decode(e))).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _emit();
  }

  Future<void> _save() async {
    final prefs = await _prefs;
    final list = _cache.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_key, list);
  }

  void _emit() => _controller.add(List.unmodifiable(_cache));

  @override
  Stream<List<Exercise>> watchAll() {
    Future.microtask(_emit);
    return _controller.stream;
  }

  @override
  Future<List<Exercise>> getAll() async {
    if (_cache.isEmpty) await _load();
    return List.unmodifiable(_cache);
  }

  @override
  Future<Exercise?> getById(String id) async {
    if (_cache.isEmpty) await _load();
    final i = _cache.indexWhere((e) => e.id == id);
    return i == -1 ? null : _cache[i];
  }

  @override
  Future<void> upsert(Exercise e) async {
    final i = _cache.indexWhere((x) => x.id == e.id);
    if (i >= 0) {
      _cache[i] = e;
    } else {
      _cache.insert(0, e);
    }
    await _save();
    _emit();
  }

  @override
  Future<void> delete(String id) async {
    _cache.removeWhere((x) => x.id == id);
    await _save();
    _emit();
  }
}
