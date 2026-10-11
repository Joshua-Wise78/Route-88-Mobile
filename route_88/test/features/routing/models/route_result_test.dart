import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/route_result.dart';

void main() {
  group('RouteResult', () {
    test('fromJson parses geojson route response from backend correctly', () {
      final json = {
        'distance': 1520.0,
        'duration': 180.5,
        'geometry': {
          'type': 'LineString',
          'coordinates': [
            [-83.0019, 39.9612],
            [-83.0025, 39.9620],
          ],
        },
        'startLocation': {'lat': 39.9612, 'lon': -83.0019},
        'endLocaiton': {'lat': 39.9620, 'lon': -83.0025},
        'steps': [
          {
            'instruction': 'Head north on High St',
            'distancemeters': 500.0,
            'durationSeconds': 60.0,
            'location': {'lat': 39.9612, 'lon': -83.0019},
            'manueverType': 'depart',
          },
        ],
      };

      final result = RouteResult.fromJson(json);

      expect(result.distanceMeters, equals(1520.0));
      expect(result.durationSeconds, equals(180.5));
      expect(result.coordinates.length, equals(2));
      expect(result.coordinates[0].lat, equals(39.9612));
      expect(result.coordinates[0].lng, equals(-83.0019));
      expect(result.coordinates[1].lat, equals(39.9620));
      expect(result.coordinates[1].lng, equals(-83.0025));
      expect(result.startLocation, isNotNull);
      expect(result.startLocation!.lat, equals(39.9612));
      expect(result.endLocation, isNotNull);
      expect(result.endLocation!.lat, equals(39.9620));
      expect(result.steps.length, equals(1));
      expect(result.steps.first.instruction, equals('Head north on High St'));
    });

    test('toJson encodes geometry and steps correctly', () {
      const result = RouteResult(
        coordinates: [
          Coordinate(lat: 39.9, lng: -83),
        ],
        distanceMeters: 100,
        durationSeconds: 10,
        steps: [],
      );

      final json = result.toJson();

      expect(json['distance'], equals(100));
      expect(json['duration'], equals(10));
      expect(
        (json['geometry'] as Map<String, dynamic>)['coordinates'],
        equals([
          [-83, 39.9],
        ]),
      );
    });

    test('copyWith updates properties properly', () {
      const result = RouteResult(
        coordinates: [],
        distanceMeters: 100,
        durationSeconds: 10,
        steps: [],
      );

      final updated = result.copyWith(distanceMeters: 250);
      expect(updated.distanceMeters, equals(250));
      expect(updated.durationSeconds, equals(10));
    });

    test('props handles equatable comparison', () {
      const r1 = RouteResult(
        coordinates: [],
        distanceMeters: 100,
        durationSeconds: 10,
        steps: [],
      );
      const r2 = RouteResult(
        coordinates: [],
        distanceMeters: 100,
        durationSeconds: 10,
        steps: [],
      );

      expect(r1, equals(r2));
    });
  });
}
