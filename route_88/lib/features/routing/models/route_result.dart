import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/route_step.dart';

class RouteResult extends Equatable {
  const RouteResult({
    required this.coordinates,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.steps,
    this.startLocation,
    this.endLocation,
  });

  factory RouteResult.fromJson(Map<String, dynamic> json) {
    // The backend returns geojson coordinates as a list of [lon, lat]
    final geom = json['geometry'];
    final List<Coordinate> parsedCoords;

    if (geom is Map<String, dynamic> && geom['coordinates'] is List) {
      final coordsList = geom['coordinates'] as List<dynamic>;
      parsedCoords = coordsList.map((c) {
        final point = c as List<dynamic>;
        return Coordinate(
          lat: (point[1] as num).toDouble(),
          lng: (point[0] as num).toDouble(),
        );
      }).toList();
    } else if (geom is List) {
      parsedCoords = geom.map((c) {
        final point = c as List<dynamic>;
        return Coordinate(
          lat: (point[1] as num).toDouble(),
          lng: (point[0] as num).toDouble(),
        );
      }).toList();
    } else {
      parsedCoords = const [];
    }

    final distance =
        (json['distance'] ?? json['distanceMeters']) as num? ?? 0.0;
    final duration =
        (json['duration'] ?? json['durationSeconds']) as num? ?? 0.0;
    final stepsList = json['steps'] as List<dynamic>? ?? [];

    final startLocJson = json['startLocation'] as Map<String, dynamic>?;
    final endLocJson =
        (json['endLocation'] ?? json['endLocaiton']) as Map<String, dynamic>?;

    return RouteResult(
      coordinates: parsedCoords,
      distanceMeters: distance.toDouble(),
      durationSeconds: duration.toDouble(),
      steps: stepsList
          .map((s) => RouteStep.fromJson(s as Map<String, dynamic>))
          .toList(),
      startLocation: startLocJson != null
          ? Coordinate.fromJson(startLocJson)
          : (parsedCoords.isNotEmpty ? parsedCoords.first : null),
      endLocation: endLocJson != null
          ? Coordinate.fromJson(endLocJson)
          : (parsedCoords.isNotEmpty ? parsedCoords.last : null),
    );
  }

  final List<Coordinate> coordinates;
  final double distanceMeters;
  final double durationSeconds;
  final List<RouteStep> steps;
  final Coordinate? startLocation;
  final Coordinate? endLocation;

  RouteResult copyWith({
    List<Coordinate>? coordinates,
    double? distanceMeters,
    double? durationSeconds,
    List<RouteStep>? steps,
    Coordinate? startLocation,
    Coordinate? endLocation,
  }) {
    return RouteResult(
      coordinates: coordinates ?? this.coordinates,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      steps: steps ?? this.steps,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
    );
  }

  Map<String, dynamic> toJson() => {
    'geometry': {
      'type': 'LineString',
      'coordinates': coordinates.map((c) => [c.lng, c.lat]).toList(),
    },
    'distance': distanceMeters,
    'duration': durationSeconds,
    if (startLocation != null) 'startLocation': startLocation!.toJson(),
    if (endLocation != null) 'endLocation': endLocation!.toJson(),
    'steps': steps.map((s) => s.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    coordinates,
    distanceMeters,
    durationSeconds,
    steps,
    startLocation,
    endLocation,
  ];
}
