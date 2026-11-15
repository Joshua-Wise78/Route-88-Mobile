import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

/// Represents the geometric path and travel metrics for a commute route.
class CommuteRoute extends Equatable {
  /// 1. Main Constructor First
  const CommuteRoute({
    required this.totalDistanceMiles,
    required this.totalDurationSeconds,
    required this.start,
    required this.end,
    required this.coordinates,
    this.isEstimatedRoute = false,
  });

  /// 2. Factory Constructors Next
  factory CommuteRoute.fromJson(Map<String, dynamic> json) {
    final startJson = json['start'] as Map<String, dynamic>? ?? {};
    final endJson = json['end'] as Map<String, dynamic>? ?? {};

    final startCoord = Coordinate(
      lat: (startJson['lat'] as num?)?.toDouble() ?? 0.0,
      lng: ((startJson['lon'] ?? startJson['lng']) as num?)?.toDouble() ?? 0.0,
    );

    final endCoord = Coordinate(
      lat: (endJson['lat'] as num?)?.toDouble() ?? 0.0,
      lng: ((endJson['lon'] ?? endJson['lng']) as num?)?.toDouble() ?? 0.0,
    );

    final geom = json['geometry'];
    final List<Coordinate> parsedCoords;

    if (geom is Map<String, dynamic> && geom['coordinates'] is List) {
      final rawCoords = geom['coordinates'] as List<dynamic>;
      parsedCoords = rawCoords.map((point) {
        final pair = point as List<dynamic>;
        return Coordinate(
          lat: (pair[1] as num).toDouble(),
          lng: (pair[0] as num).toDouble(),
        );
      }).toList();
    } else if (json['coordinates'] is List) {
      final rawCoords = json['coordinates'] as List<dynamic>;
      parsedCoords = rawCoords.map((point) {
        final pair = point as List<dynamic>;
        return Coordinate(
          lat: (pair[1] as num).toDouble(),
          lng: (pair[0] as num).toDouble(),
        );
      }).toList();
    } else {
      parsedCoords = [startCoord, endCoord];
    }

    return CommuteRoute(
      totalDistanceMiles:
          (json['totalDistanceMiles'] as num?)?.toDouble() ?? 0.0,
      totalDurationSeconds:
          (json['totalDurationSeconds'] as num?)?.toInt() ?? 0,
      start: startCoord,
      end: endCoord,
      coordinates: parsedCoords,
      isEstimatedRoute: json['isEstimatedRoute'] as bool? ?? false,
    );
  }

  /// 3. Final Fields Below Constructors
  final double totalDistanceMiles;
  final int totalDurationSeconds;
  final Coordinate start;
  final Coordinate end;
  final List<Coordinate> coordinates;
  final bool isEstimatedRoute;

  /// Human-readable duration (e.g. "45 min" or "1 hr 15 min")
  String get formattedDuration {
    final minutes = (totalDurationSeconds / 60).round();
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes == 0
        ? '$hours hr'
        : '$hours hr $remainingMinutes min';
  }

  /// Human-readable distance (e.g. "32.4 mi")
  String get formattedDistance => '${totalDistanceMiles.toStringAsFixed(1)} mi';

  /// 4. Methods / Overrides
  Map<String, dynamic> toJson() => {
        'totalDistanceMiles': totalDistanceMiles,
        'totalDurationSeconds': totalDurationSeconds,
        'start': {'lat': start.lat, 'lon': start.lng},
        'end': {'lat': end.lat, 'lon': end.lng},
        'isEstimatedRoute': isEstimatedRoute,
        'geometry': {
          'type': 'LineString',
          'coordinates': coordinates.map((c) => [c.lng, c.lat]).toList(),
        },
      };

  @override
  List<Object?> get props => [
        totalDistanceMiles,
        totalDurationSeconds,
        start,
        end,
        coordinates,
        isEstimatedRoute,
      ];
}
