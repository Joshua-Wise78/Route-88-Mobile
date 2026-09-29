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
    return Place(
      id: json['id'].toString(),
      displayName: json['displayName'] as String? ?? 'Unknown',
      street: json['street'] as String?,
      city: json['city'] as String?,
      coordinate: Coordinate(
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lon'] as num).toDouble(),
      ),
    );
  }

  final String id;
  final String displayName;
  final String? street;
  final String? city;
  final Coordinate coordinate;

  @override
  List<Object?> get props => [id, displayName, street, city, coordinate];
}
