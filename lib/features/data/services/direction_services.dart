import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';


class DirectionsService {
  static const _httpsBases = <String>[
    'https://router.project-osrm.org/route/v1/driving',
    'https://routing.openstreetmap.de/routed-car/route/v1/driving',
    'https://routing.isochrone.app/route/v1/driving',
  ];

  final http.Client _client = http.Client();

  Future<List<LatLng>?> route(LatLng from, LatLng to) async {
    for (final base in _httpsBases) {
      final r = await _tryFetch(base, from, to);
      if (r != null && r.isNotEmpty) return r;
    }
    return null;
  }

  Future<List<LatLng>?> _tryFetch(
      String base, LatLng from, LatLng to) async {
    final url =
        '$base/${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
        '?overview=full&geometries=geojson';
    debugPrint('OSRM GET $url');

    try {
      final res = await _client
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 12));

      if (res.statusCode != 200) return null;

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final routes = (json['routes'] as List?) ?? const [];
      if (routes.isEmpty) return null;

      final geom = routes.first['geometry'] as Map<String, dynamic>?;
      final coords = (geom?['coordinates'] as List?)?.cast<List>() ?? const [];
      if (coords.isEmpty) return null;

      return coords
          .map((p) => LatLng((p[1] as num).toDouble(), (p[0] as num).toDouble()))
          .toList();
    } on HandshakeException catch (e) {
      debugPrint('OSRM HandshakeException on $base: $e');
      return null;
    } on SocketException catch (e) {
      debugPrint('OSRM SocketException on $base: $e');
      return null;
    } catch (e) {
      debugPrint('OSRM error on $base: $e');
      return null;
    }
  }
}
