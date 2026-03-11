import '../entities/tag_def.dart';

abstract class TagRepository {
  Future<List<TagDef>> getAll();
  Future<void> upsert(TagDef tag);        
  Future<void> delete(String name);
}
