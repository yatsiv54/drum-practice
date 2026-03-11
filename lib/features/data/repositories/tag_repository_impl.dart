import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/tag_def.dart';
import '../../domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  static const _key = 'tags_catalog';
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<List<TagDef>> getAll() async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => TagDef.fromJson(json.decode(e))).toList();
  }

  @override
  Future<void> upsert(TagDef tag) async {
    final prefs = await _prefs;
    final list = await getAll();
    final i = list.indexWhere((t) => t.name.toLowerCase() == tag.name.toLowerCase());
    if (i >= 0) {
      list[i] = tag;
    } else {
      list.add(tag);
    }
    await prefs.setStringList(_key, list.map((t) => json.encode(t.toJson())).toList());
  }

  @override
  Future<void> delete(String name) async {
    final prefs = await _prefs;
    final list = await getAll()..removeWhere((t) => t.name.toLowerCase() == name.toLowerCase());
    await prefs.setStringList(_key, list.map((t) => json.encode(t.toJson())).toList());
  }
}
