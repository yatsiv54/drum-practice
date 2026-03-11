
import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:drum_practice_app/features/domain/entities/plan.dart';
import 'package:drum_practice_app/features/domain/repositories/plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  static const _key = 'plans_v1';

  final _controller = StreamController<List<Plan>>.broadcast();
  List<Plan> _cache = [];

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  PlanRepositoryImpl() {
    _load(); 
  }

  

  Future<void> _load() async {
    final p = await _prefs;
    final raw = p.getString(_key);
    if (raw == null) {
      _cache = [];
    } else {
      final List data = jsonDecode(raw);
      _cache =
          data.map((e) => Plan.fromJson(e as Map<String, dynamic>)).toList();
    }
    _emit();
  }

  Future<void> _save() async {
    final p = await _prefs;
    await p.setString(
      _key,
      jsonEncode(_cache.map((e) => e.toJson()).toList()),
    );
  }

  void _emit() {
    
    _controller.add(List.unmodifiable(_cache));
  }
  @override
  Future<void> deleteAll() async {
    _cache = [];
    await _save(); 
    _emit(); 
  }
  

  @override
  Stream<List<Plan>> watchAll() {
    
    Future.microtask(_emit);
    return _controller.stream;
  }

  @override
  Future<List<Plan>> getAll() async {
    if (_cache.isEmpty) await _load();
    return List.unmodifiable(_cache);
  }

  @override
  Future<Plan?> getById(String id) async {
    if (_cache.isEmpty) await _load();
    return _cache.firstWhereOrNull((p) => p.id.trim() == id.trim());
  }

  @override
  Future<void> upsert(Plan plan) async {
    final i = _cache.indexWhere((e) => e.id == plan.id);
    if (i >= 0) {
      _cache[i] = plan;
    } else {
      _cache.add(plan);
    }
    await _save();
    _emit();
  }

  @override
  Future<void> delete(String id) async {
    _cache.removeWhere((e) => e.id == id);
    await _save();
    _emit();
  }

  
  Future<void> close() async {
    await _controller.close();
  }
}
