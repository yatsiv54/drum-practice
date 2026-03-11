import 'package:latlong2/latlong.dart';

class School {
  final String name;
  final LatLng coord;
  final String? address;
  final String? phone;
  final String? openingHours;

  
  final String? osmType; 
  final String? osmId;   

  const School({
    required this.name,
    required this.coord,
    this.address,
    this.phone,
    this.openingHours,
    this.osmType,
    this.osmId,
  });

  School copyWith({
    String? name,
    LatLng? coord,
    String? address,
    String? phone,
    String? openingHours,
    String? osmType,
    String? osmId,
  }) {
    return School(
      name: name ?? this.name,
      coord: coord ?? this.coord,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      openingHours: openingHours ?? this.openingHours,
      osmType: osmType ?? this.osmType,
      osmId: osmId ?? this.osmId,
    );
  }
}
