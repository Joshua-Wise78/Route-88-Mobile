import 'package:equatable/equatable.dart';

class RouteResult extends Equatable {
  const RouteResult({
    required this.polyline,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  factory RouteResult.fromJson(Map<String, dynamic> json) {
    final route =
        (json['routes'] as List<dynamic>).first as Map<String, dynamic>;

    return RouteResult(
      polyline: route['geometry'] as String,
      distanceMeters: (route['distance'] as num).toDouble(),
      durationSeconds: (route['duration'] as num).toDouble(),
    );
  }

  final String polyline;
  final double distanceMeters;
  final double durationSeconds;

  @override
  List<Object?> get props => [polyline, distanceMeters, durationSeconds];
}
