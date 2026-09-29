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
    final loc = json['location'] as Map<String, dynamic>;
    return RouteStep(
      instruction: json['instruction'] as String,
      distanceMeters: (json['distancemeters'] as num).toDouble(),
      durationSeconds: (json['durationSeconds'] as num).toDouble(),
      location: Coordinate(
        lat: (loc['lat'] as num).toDouble(),
        lng: (loc['lon'] as num).toDouble(),
      ),
      maneuverType: json['manueverType'] as String,
      maneuverModifier: json['manueverModifier'] as String?,
    );
  }

  final String instruction;
  final double distanceMeters;
  final double durationSeconds;
  final Coordinate location;
  final String maneuverType;
  final String? maneuverModifier;

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
