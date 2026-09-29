import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/route_step.dart';

class RouteResult extends Equatable {
  const RouteResult({
    required this.coordinates,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.steps,
  });

  factory RouteResult.fromJson(Map<String, dynamic> json) {
    // The backend returns geojson coordinates as a list of [lon, lat]
    final geom = json['geometry'] as Map<String, dynamic>;
    final coordsList = geom['coordinates'] as List<dynamic>;

    final parsedCoords = coordsList.map((c) {
      final point = c as List<dynamic>;
      return Coordinate(
        lat: (point[1] as num).toDouble(),
        lng: (point[0] as num).toDouble(),
      );
    }).toList();

    final stepsList = json['steps'] as List<dynamic>? ?? [];

    return RouteResult(
      coordinates: parsedCoords,
      distanceMeters: (json['distance'] as num).toDouble(),
      durationSeconds: (json['duration'] as num).toDouble(),
      steps: stepsList
          .map((s) => RouteStep.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<Coordinate> coordinates;
  final double distanceMeters;
  final double durationSeconds;
  final List<RouteStep> steps;

  @override
  List<Object?> get props => [
    coordinates,
    distanceMeters,
    durationSeconds,
    steps,
  ];
}
