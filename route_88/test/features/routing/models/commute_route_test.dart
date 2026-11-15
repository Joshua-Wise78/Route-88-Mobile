import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/routing/models/commute_route.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

void main() {
  group('CommuteRoute', () {
    test('fromJson parses geometry coordinates and metrics correctly', () {
      final json = {
        'totalDistanceMiles': 108.5,
        'totalDurationSeconds': 6420,
        'start': {'lat': 39.9612, 'lon': -83.0019},
        'end': {'lat': 39.1031, 'lon': -84.5120},
        'isEstimatedRoute': false,
        'geometry': {
          'type': 'LineString',
          'coordinates': [
            [-83.0019, 39.9612],
            [-83.5000, 39.5000],
            [-84.5120, 39.1031],
          ],
        },
      };

      final route = CommuteRoute.fromJson(json);

      expect(route.totalDistanceMiles, equals(108.5));
      expect(route.totalDurationSeconds, equals(6420));
      expect(route.start.lat, equals(39.9612));
      expect(route.start.lng, equals(-83.0019));
      expect(route.end.lat, equals(39.1031));
      expect(route.end.lng, equals(-84.5120));
      expect(route.coordinates.length, equals(3));
      expect(route.coordinates[0].lat, equals(39.9612));
      expect(route.coordinates[0].lng, equals(-83.0019));
      expect(route.isEstimatedRoute, isFalse);
      expect(route.formattedDistance, equals('108.5 mi'));
      expect(route.formattedDuration, equals('1 hr 47 min'));
    });

    test('formattedDuration handles minutes only under 60 minutes', () {
      const route = CommuteRoute(
        totalDistanceMiles: 25.0,
        totalDurationSeconds: 1800, // 30 minutes
        start: Coordinate(lat: 39.96, lng: -83.00),
        end: Coordinate(lat: 40.05, lng: -83.10),
        coordinates: [],
      );

      expect(route.formattedDuration, equals('30 min'));
    });

    test('toJson generates expected map representation', () {
      const route = CommuteRoute(
        totalDistanceMiles: 12.4,
        totalDurationSeconds: 900,
        start: Coordinate(lat: 39.96, lng: -83.00),
        end: Coordinate(lat: 40.05, lng: -83.10),
        coordinates: [
          Coordinate(lat: 39.96, lng: -83.00),
          Coordinate(lat: 40.05, lng: -83.10),
        ],
      );

      final json = route.toJson();

      expect(json['totalDistanceMiles'], equals(12.4));
      expect(json['totalDurationSeconds'], equals(900));
      expect(json['start'], equals({'lat': 39.96, 'lon': -83.00}));
      expect(json['end'], equals({'lat': 40.05, 'lon': -83.10}));
      expect(json['geometry'], isNotNull);
    });
  });
}
