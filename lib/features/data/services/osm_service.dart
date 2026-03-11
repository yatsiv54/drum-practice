import 'dart:convert';
import 'package:drum_practice_app/features/data/models/school.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsmService {
  final http.Client _client = http.Client();

  static const _ua = {
    'User-Agent': 'drum-journal/1.0 (overpass+nominatim)',
    'Accept': 'application/json',
  };

  // Кілька ендпоїнтів Overpass — підміняємо, якщо перший лежить/повільний
  static const List<String> _overpassEndpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
    'https://lz4.overpass-api.de/api/interpreter',
  ];

  /// Пошук музичних шкіл за OSM-тегами в радіусі [radius] (м)
  Future<List<School>> searchAround(LatLng center, {int radius = 20000}) async {
    final query = _buildOverpassQuery(center, radius);

    Map<String, dynamic>? json;
    for (final ep in _overpassEndpoints) {
      try {
        final res = await _client.post(
          Uri.parse(ep),
          headers: {
            ..._ua,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {'data': query},
        );
        if (res.statusCode == 200) {
          json = (jsonDecode(res.body) as Map).cast<String, dynamic>();
          break;
        }
      } catch (_) {
        // спробуємо наступний ендпоїнт
      }
    }
    if (json == null) return [];

    final elements = (json['elements'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();

    // Дедуплікація по type+id
    final byKey = <String, School>{};

    for (final el in elements) {
      final type = (el['type'] as String?) ?? '';
      final id = el['id']?.toString();
      if (type.isEmpty || id == null) continue;

      double? lat;
      double? lon;

      if (type == 'node') {
        final latNum = el['lat'];
        final lonNum = el['lon'];
        if (latNum is num && lonNum is num) {
          lat = latNum.toDouble();
          lon = lonNum.toDouble();
        }
      } else {
        final c = el['center'];
        if (c is Map) {
          final latNum = c['lat'];
          final lonNum = c['lon'];
          if (latNum is num && lonNum is num) {
            lat = latNum.toDouble();
            lon = lonNum.toDouble();
          }
        }
      }
      if (lat == null || lon == null) continue;

      final tags = (el['tags'] as Map?)?.cast<String, dynamic>() ?? const {};
      final name = _bestName(tags);
      final opening = tags['opening_hours'] as String?;
      final phone = (tags['phone'] ??
              tags['contact:phone'] ??
              tags['contact:mobile']) as String?;
      final address = _composeAddress(tags);

      final s = School(
        name: name,
        coord: LatLng(lat, lon),
        address: (address == null || address.trim().isEmpty)
            ? null
            : address.trim(),
        phone: phone,
        openingHours: opening,
        osmType: type[0].toUpperCase(),
        osmId: id,
      );

      byKey['${s.osmType}${s.osmId}'] = s;
    }

    return byKey.values.toList();
  }

  /// Якщо не вистачає телефону/годин — добираємо з Nominatim lookup
  Future<School> enrichIfNeeded(School s) async {
    if ((s.phone != null && s.openingHours != null) ||
        s.osmType == null ||
        s.osmId == null) {
      return s;
    }
    final osmKey = '${s.osmType}${s.osmId}';
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/lookup'
      '?osm_ids=$osmKey&format=json&extratags=1&addressdetails=1',
    );

    final res = await _client.get(uri, headers: _ua);
    if (res.statusCode != 200) return s;
    final arr = (jsonDecode(res.body) as List);
    if (arr.isEmpty) return s;

    final j = arr.first as Map<String, dynamic>;
    final extra = (j['extratags'] as Map?) ?? const {};
    final opening = (extra['opening_hours'] ?? s.openingHours) as String?;
    final phone = (extra['phone'] ??
            extra['contact:phone'] ??
            extra['contact:mobile'] ??
            s.phone) as String?;
    final address = (j['display_name'] as String?) ?? s.address;

    return s.copyWith(
      openingHours: opening,
      phone: phone,
      address: address,
    );
  }

  /// Геокодування міста (Nominatim), щоб знайти центр для пошуку
  Future<LatLng?> geocodeCity(String city) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$city&format=json&limit=1',
    );
    final res = await _client.get(uri, headers: _ua);
    if (res.statusCode != 200) return null;
    final arr = (jsonDecode(res.body) as List);
    if (arr.isEmpty) return null;
    final j = arr.first as Map;
    final lat = double.tryParse(j['lat'] as String? ?? '');
    final lon = double.tryParse(j['lon'] as String? ?? '');
    if (lat == null || lon == null) return null;
    return LatLng(lat, lon);
  }

  /// Запит Overpass: шукаємо по коректних тегах музичних шкіл
  String _buildOverpassQuery(LatLng c, int radius) {
    final lat = c.latitude.toStringAsFixed(6);
    final lon = c.longitude.toStringAsFixed(6);

    // 1) canonical: amenity=music_school
    // 2) дехто мапить як amenity=school + school=music
    // 3) або amenity=school + school:subject=music
    return '''
[out:json][timeout:25];
(
  node["amenity"="music_school"](around:$radius,$lat,$lon);
  way["amenity"="music_school"](around:$radius,$lat,$lon);
  relation["amenity"="music_school"](around:$radius,$lat,$lon);

  node["amenity"="school"]["school"="music"](around:$radius,$lat,$lon);
  way["amenity"="school"]["school"="music"](around:$radius,$lat,$lon);
  relation["amenity"="school"]["school"="music"](around:$radius,$lat,$lon);

  node["amenity"="school"]["school:subject"~"^music\$",i](around:$radius,$lat,$lon);
  way["amenity"="school"]["school:subject"~"^music\$",i](around:$radius,$lat,$lon);
  relation["amenity"="school"]["school:subject"~"^music\$",i](around:$radius,$lat,$lon);
);
out center;
''';
  }

  static String _bestName(Map<String, dynamic> tags) {
    final n = tags['name'];
    if (n is String && n.trim().isNotEmpty) return n.trim();
    // якщо локалізоване ім'я
    for (final e in tags.entries) {
      if (e.key.startsWith('name:') && e.value is String) {
        final v = (e.value as String).trim();
        if (v.isNotEmpty) return v;
      }
    }
    return 'Music school';
  }

  static String? _composeAddress(Map<String, dynamic> tags) {
    if (tags['addr:full'] is String) {
      final v = (tags['addr:full'] as String).trim();
      if (v.isNotEmpty) return v;
    }
    final parts = <String>[];
    void add(String k) {
      final v = tags[k];
      if (v is String && v.trim().isNotEmpty) parts.add(v.trim());
    }

    add('addr:street');
    add('addr:housenumber');
    if (parts.isNotEmpty) parts.add(','); // роздільник між вулицею та нас. пунктом
    add('addr:city');
    add('addr:postcode');
    add('addr:country');

    final s = parts.join(' ');
    if (s.trim().isEmpty) return null;
    // прибрати можливі зайві коми/пробіли
    return s.replaceAll(RegExp(r'\s+,|,\s*,+'), ', ').trim();
  }
}
