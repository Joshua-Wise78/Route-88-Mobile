import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

class Place extends Equatable {
  const Place({
    required this.id,
    required this.displayName,
    required this.coordinate,
    this.street,
    this.city,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final coordJson = json['coordinate'];
    final Coordinate parsedCoord;
    if (coordJson is Map<String, dynamic>) {
      parsedCoord = Coordinate.fromJson(coordJson);
    } else {
      parsedCoord = Coordinate(
        lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
        lng: ((json['lon'] ?? json['lng']) as num?)?.toDouble() ?? 0.0,
      );
    }

    return Place(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName'] as String? ?? 'Unknown',
      street: json['street'] as String?,
      city: json['city'] as String?,
      coordinate: parsedCoord,
    );
  }

  final String id;
  final String displayName;
  final String? street;
  final String? city;
  final Coordinate coordinate;

  Place copyWith({
    String? id,
    String? displayName,
    String? street,
    String? city,
    Coordinate? coordinate,
  }) {
    return Place(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      street: street ?? this.street,
      city: city ?? this.city,
      coordinate: coordinate ?? this.coordinate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    if (street != null) 'street': street,
    if (city != null) 'city': city,
    'coordinate': coordinate.toJson(),
    'lat': coordinate.lat,
    'lon': coordinate.lng,
  };

  @override
  List<Object?> get props => [id, displayName, street, city, coordinate];
}
