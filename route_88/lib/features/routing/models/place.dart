import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

class Place extends Equatable {
  const Place({
    required this.name,
    required this.coordinate,
    this.city,
    this.state,
    this.country,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] as Map<String, dynamic>;
    final geometry = json['geometry'] as Map<String, dynamic>;
    final coords = geometry['coordinates'] as List<dynamic>;

    return Place(
      name: properties['name'] as String? ?? 'Unknown',
      city: properties['city'] as String?,
      state: properties['state'] as String?,
      country: properties['country'] as String?,
      coordinate: Coordinate(
        lng: (coords[0] as num).toDouble(),
        lat: (coords[1] as num).toDouble(),
      ),
    );
  }

  final String name;
  final String? city;
  final String? state;
  final String? country;
  final Coordinate coordinate;

  String get displayName =>
      [name, city, state].where((e) => e != null).join(', ');

  @override
  List<Object?> get props => [name, city, state, country, coordinate];
}
