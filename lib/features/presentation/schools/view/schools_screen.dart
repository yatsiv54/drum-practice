import 'dart:ui' as ui;
import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';
import 'package:drum_practice_app/features/data/models/school.dart';
import 'package:drum_practice_app/features/data/services/direction_services.dart';
import 'package:drum_practice_app/features/data/services/osm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/custom_button.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  final _map = MapController();
  final _svc = OsmService();
  final _dir = DirectionsService();
  final _searchCtrl = TextEditingController();

  LatLng? _center;
  bool _loading = true;
  List<School> _items = [];
  int? _selected;

  bool _routing = false;
  int _routingSeq = 0;
  LatLng? _myPos;
  List<LatLng>? _route;

  bool _enriching = false;

  final Color _routeStartColor = const Color(0xFF1F4287);
  final Color _routeEndColor = const Color(0xFF8EC5FF);

  @override
  void initState() {
    super.initState();
    _centerOnMyLocation();
  }

  Future<void> _centerOnMyLocation() async {
    setState(() {
      _loading = true;
      _items = [];
      _selected = null;
      _route = null;
    });

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are disabled';
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        throw 'Location permission denied';
      }

      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 6));
      } catch (_) {
        pos = await Geolocator.getLastKnownPosition();
      }
      if (pos == null) throw 'Can’t get current position';

      final here = LatLng(pos.latitude, pos.longitude);
      _myPos = here;
      setState(() => _center = here);

      _map.move(here, 12);
      await _load();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _center ??= const LatLng(0, 0);
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _load() async {
    if (_center == null) return;
    setState(() {
      _loading = true;
      _route = null;
    });
    try {
      final list = await _svc.searchAround(_center!, radius: 12000);
      if (!mounted) return;
      setState(() {
        _items = list;
        _selected = null; // НЕ вибираємо автоматично
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _items = [];
        _selected = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load schools: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _goToCity(String q) async {
    if (q.trim().isEmpty) return;

    // Ховаємо картку і скасовуємо навігацію вже при старті пошуку
    setState(() {
      _selected = null;
      _route = null;
    });

    final p = await _svc.geocodeCity(q.trim());
    if (p == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('City not found')));
      return;
    }
    setState(() {
      _center = p;
      _route = null;
      _selected = null;
    });
    _map.move(p, 12);
    await _load();
  }

  Future<bool> _ensureLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return !(perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever);
  }

  List<LatLng> _decimate(List<LatLng> pts, {int step = 3}) {
    if (pts.length <= 500) return pts;
    final out = <LatLng>[];
    for (var i = 0; i < pts.length; i += step) {
      out.add(pts[i]);
    }
    if (out.isEmpty ||
        out.last.latitude != pts.last.latitude ||
        out.last.longitude != pts.last.longitude) {
      out.add(pts.last);
    }
    return out;
  }

  List<Polyline> _buildGradientPolylines() {
    if (_route == null || _route!.length < 2) return [];
    final d = const Distance();

    double total = 0;
    for (int i = 0; i < _route!.length - 1; i++) {
      total += d.as(LengthUnit.Meter, _route![i], _route![i + 1]);
    }
    if (total == 0) {
      return [Polyline(points: _route!, strokeWidth: 6, color: _routeEndColor)];
    }

    final out = <Polyline>[];
    double acc = 0;
    for (int i = 0; i < _route!.length - 1; i++) {
      final a = _route![i];
      final b = _route![i + 1];
      final seg = d.as(LengthUnit.Meter, a, b);
      final t = ((acc + seg / 2) / total).clamp(0.0, 1.0);
      final c = Color.lerp(_routeStartColor, _routeEndColor, t)!;
      out.add(Polyline(points: [a, b], strokeWidth: 6, color: c));
      acc += seg;
    }
    return out;
  }

  Future<void> _buildRouteTo(School s) async {
    final mySeq = ++_routingSeq;
    if (!await _ensureLocationPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission required')),
      );
      return;
    }

    setState(() => _routing = true);
    try {
      Position? p;
      try {
        p = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 6));
      } catch (_) {
        p = await Geolocator.getLastKnownPosition();
      }
      if (p == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Can’t get your location')),
        );
        setState(() => _routing = false);
        return;
      }
      final from = LatLng(p.latitude, p.longitude);
      final to = s.coord;

      final r = await _dir
          .route(from, to)
          .timeout(const Duration(seconds: 12), onTimeout: () => null);

      if (!mounted) return;
      if (mySeq != _routingSeq) return;

      if (r == null || r.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Route not found')));
        setState(() => _routing = false);
        return;
      }

      final simplified = _decimate(r, step: 3);

      setState(() {
        _myPos = from;
        _route = simplified;
        _routing = false;
        _selected = null; // ховаємо картку під час навігації
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _route == null || _route!.length < 2) return;
        final bounds = LatLngBounds.fromPoints(_route!);
        _map.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.fromLTRB(28, 120, 28, 220),
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _routing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to build route: $e')));
    }
  }

  Future<void> _openExternal(School s) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${s.coord.latitude},${s.coord.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _selectIndex(int i) async {
    // Якщо була навігація — скасовуємо її при виборі іншої точки
    setState(() {
      _route = null;
      _selected = i;
      _enriching = true;
    });
    final enriched = await _svc.enrichIfNeeded(_items[i]);
    if (!mounted) return;
    setState(() {
      _items[i] = enriched;
      _enriching = false;
    });
  }

  void _cancelRoute() {
    setState(() {
      _route = null;
    });
  }

  Future<void> _locateMe() async {
    if (_myPos != null) {
      _map.move(_myPos!, 15);
    } else {
      await _centerOnMyLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected != null && _selected! < _items.length
        ? _items[_selected!]
        : null;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Schools Search',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                      ),
                      initialCenter: _center ?? const LatLng(0, 0),
                      initialZoom: _center == null ? 2 : 12.2,
                      onTap: (_, __) => setState(() => _selected = null),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.drum_practice_app',
                      ),
                      if (_route != null && _route!.length > 1)
                        PolylineLayer(polylines: _buildGradientPolylines()),
                      MarkerLayer(
                        markers: [
                          if (_myPos != null)
                            Marker(
                              point: _myPos!,
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              child: _AssetPinGradient(
                                asset: 'assets/images/geo.png',
                                colors: const [
                                  Color(0xFF9BD2FF),
                                  Color(0xFF2A6BB0),
                                ],
                                size: 40,
                              ),
                            ),
                          for (int i = 0; i < _items.length; i++)
                            Marker(
                              point: _items[i].coord,
                              width: 78,
                              height: 90,
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () => _selectIndex(i),
                                child: _AssetPinGradient(
                                  asset: 'assets/images/point.png',
                                  colors: i == _selected
                                      ? const [
                                          Color(0xFFE7FFBF),
                                          Color(0xFF80AB3A),
                                        ]
                                      : const [
                                          Color(0xFF8DC0FF),
                                          Color(0xFF2C6AA6),
                                        ],
                                  size: 86,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 16,
                  right: 16,
                  top: 8,
                  child: SafeArea(
                    bottom: false,
                    child: _SearchBar(
                      controller: _searchCtrl,
                      onTap: () {
                        // Ховаємо картку при простому тапі по полю пошуку
                        setState(() {
                          _selected = null;
                        });
                      },
                      onSubmit: (q) {
                        setState(() => _selected = null);
                        _goToCity(q);
                      },
                    ),
                  ),
                ),

                if (_loading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),

                if (selected != null && _route == null)
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              _SchoolCard(school: selected),
                              if (_enriching)
                                const Positioned.fill(
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 48),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  height: 75,
                                  text: _routing
                                      ? 'Routing...'
                                      : 'Get directions',
                                  onPressed: _routing
                                      ? () {}
                                      : () {
                                          setState(() => _selected = null);
                                          _buildRouteTo(selected);
                                        },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                if (_route != null && _route!.length > 1)
                  Positioned(
                    right: 16,
                    bottom: 20,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Color.fromRGBO(220, 0, 4, 1),
                            shape: const CircleBorder(),
                            heroTag: 'cancelNav',
                            onPressed: _cancelRoute,
                            child: Image.asset(
                              'assets/icons/cross.png',
                              scale: 17,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            heroTag: 'locateMe',
                            onPressed: _locateMe,
                            child: Image.asset(
                              'assets/icons/location.png',
                              scale: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onTap;
  const _SearchBar({
    required this.controller,
    required this.onSubmit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Color.fromRGBO(106, 118, 130, 1)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Image.asset('assets/icons/search.png', scale: 28),
          const SizedBox(width: 8),
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final showHint = value.text.isEmpty;
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    if (showHint)
                      const IgnorePointer(
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    TextField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                      controller: controller,
                      onTap: onTap, // ховаємо картку при тапі
                      onSubmitted: onSubmit,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SchoolCard extends StatelessWidget {
  final School school;
  const _SchoolCard({required this.school});

  String _cleanAddress(String? name, String? address) {
    if (address == null) return '';
    var a = address.trim();
    if (name != null && name.trim().isNotEmpty) {
      final n = name.trim();
      if (a.toLowerCase().startsWith(n.toLowerCase())) {
        a = a.substring(n.length).trimLeft();
        a = a.replaceFirst(RegExp(r'^(\s*[-–—,:])\s*'), '');
      }
    }
    return a;
  }

  @override
  Widget build(BuildContext context) {
    final cleanedAddress = _cleanAddress(school.name, school.address);

    return Material(
      color: Colors.white,
      elevation: 12,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '🎵 ${school.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            if (cleanedAddress.isNotEmpty) ...[
              Text(
                cleanedAddress,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            if (school.phone != null && school.phone!.trim().isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '📞${school.phone!}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F7),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        '🕘 Opening hours:',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    (school.openingHours == null ||
                            school.openingHours!.trim().isEmpty)
                        ? 'No info'
                        : school.openingHours!,
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetPinGradient extends StatelessWidget {
  final String asset;
  final List<Color> colors;
  final double size;

  const _AssetPinGradient({
    required this.asset,
    required this.colors,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) =>
          ui.Gradient.linear(rect.topCenter, rect.bottomCenter, colors),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
