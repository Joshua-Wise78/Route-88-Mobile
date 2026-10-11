import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

class RouteStep extends Equatable {
  const RouteStep({
    required this.instruction,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.location,
    required this.maneuverType,
    this.maneuverModifier,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];
    final Coordinate parsedLocation;
    if (loc is Map<String, dynamic>) {
      parsedLocation = Coordinate(
        lat: (loc['lat'] as num?)?.toDouble() ?? 0.0,
        lng: ((loc['lon'] ?? loc['lng']) as num?)?.toDouble() ?? 0.0,
      );
    } else if (loc is List && loc.length >= 2) {
      parsedLocation = Coordinate(
        lat: (loc[1] as num?)?.toDouble() ?? 0.0,
        lng: (loc[0] as num?)?.toDouble() ?? 0.0,
      );
    } else {
      parsedLocation = const Coordinate(lat: 0, lng: 0);
    }

    final distance = (json['distancemeters'] ??
            json['distanceMeters'] ??
            json['distance']) as num? ??
        0.0;
    final duration =
        (json['durationSeconds'] ?? json['duration']) as num? ?? 0.0;

    return RouteStep(
      instruction: json['instruction'] as String? ?? '',
      distanceMeters: distance.toDouble(),
      durationSeconds: duration.toDouble(),
      location: parsedLocation,
      maneuverType:
          ((json['manueverType'] ?? json['maneuverType']) as String?) ?? '',
      maneuverModifier:
          (json['manueverModifier'] ?? json['maneuverModifier']) as String?,
    );
  }

  final String instruction;
  final double distanceMeters;
  final double durationSeconds;
  final Coordinate location;
  final String maneuverType;
  final String? maneuverModifier;

  RouteStep copyWith({
    String? instruction,
    double? distanceMeters,
    double? durationSeconds,
    Coordinate? location,
    String? maneuverType,
    String? maneuverModifier,
  }) {
    return RouteStep(
      instruction: instruction ?? this.instruction,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      location: location ?? this.location,
      maneuverType: maneuverType ?? this.maneuverType,
      maneuverModifier: maneuverModifier ?? this.maneuverModifier,
    );
  }

  Map<String, dynamic> toJson() => {
    'instruction': instruction,
    'distancemeters': distanceMeters,
    'durationSeconds': durationSeconds,
    'location': {
      'lat': location.lat,
      'lon': location.lng,
    },
    'manueverType': maneuverType,
    if (maneuverModifier != null) 'manueverModifier': maneuverModifier,
  };

  @override
  List<Object?> get props => [
        instruction,
        distanceMeters,
        durationSeconds,
        location,
        maneuverType,
        maneuverModifier,
      ];
}
