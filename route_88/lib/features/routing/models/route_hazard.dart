import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

/// Represents a road hazard (incident, slowdown, construction)
/// identified within the corridor buffer along a commute route.
class RouteHazard extends Equatable {
  /// 1. Main Constructor First
  const RouteHazard({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.distanceFromRouteMiles,
    required this.mileMarkerOnRoute,
    required this.severity,
    required this.isRoadClosed,
    this.direction,
    this.routeName,
  });

  /// 2. Factory Constructors Next
  factory RouteHazard.fromJson(Map<String, dynamic> json) {
    return RouteHazard(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'incident',
      title: json['title'] as String? ?? 'Hazard',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceFromRouteMiles:
          (json['distanceFromRouteMiles'] as num?)?.toDouble() ?? 0.0,
      mileMarkerOnRoute:
          (json['mileMarkerOnRoute'] as num?)?.toDouble() ?? 0.0,
      severity: json['severity'] as String? ?? 'medium',
      isRoadClosed: json['isRoadClosed'] as bool? ?? false,
      direction: json['direction'] as String?,
      routeName: json['routeName'] as String?,
    );
  }

  /// 3. Final Fields Below Constructors
  final String id;
  final String type; // 'incident', 'slowdown', 'construction'
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final double distanceFromRouteMiles;
  final double mileMarkerOnRoute;
  final String severity; // 'low', 'medium', 'high', 'critical'
  final bool isRoadClosed;
  final String? direction;
  final String? routeName;

  /// Helper getters for UI categorization
  bool get isIncident => type == 'incident';
  bool get isSlowdown => type == 'slowdown';
  bool get isConstruction => type == 'construction';

  Coordinate get coordinate => Coordinate(lat: latitude, lng: longitude);

  /// 4. Methods / Overrides
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'description': description,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'distanceFromRouteMiles': distanceFromRouteMiles,
        'mileMarkerOnRoute': mileMarkerOnRoute,
        'severity': severity,
        'isRoadClosed': isRoadClosed,
        if (direction != null) 'direction': direction,
        if (routeName != null) 'routeName': routeName,
      };

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        location,
        latitude,
        longitude,
        distanceFromRouteMiles,
        mileMarkerOnRoute,
        severity,
        isRoadClosed,
        direction,
        routeName,
      ];
}
