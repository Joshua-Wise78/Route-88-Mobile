import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/routing/models/commute_check_result.dart';

void main() {
  group('CommuteCheckResult', () {
    test('fromJson parses complete backend payload with hazards correctly', () {
      final json = {
        'success': true,
        'isClear': false,
        'status': 'moderate_hazards',
        'summary': {
          'totalHazards': 3,
          'incidentsCount': 1,
          'slowdownsCount': 1,
          'constructionCount': 1,
          'message': '3 hazards detected along your route corridor',
        },
        'route': {
          'totalDistanceMiles': 45.2,
          'totalDurationSeconds': 2700,
          'start': {'lat': 39.9612, 'lon': -83.0019},
          'end': {'lat': 39.7589, 'lon': -84.1916},
          'isEstimatedRoute': false,
          'geometry': {
            'type': 'LineString',
            'coordinates': [
              [-83.0019, 39.9612],
              [-84.1916, 39.7589],
            ],
          },
        },
        'corridorBufferMiles': 0.31,
        'hazards': [
          {
            'id': 'inc-1',
            'type': 'incident',
            'title': 'Stalled Vehicle',
            'description': 'On shoulder',
            'location': 'I-70 W',
            'latitude': 39.90,
            'longitude': -83.50,
            'distanceFromRouteMiles': 0.02,
            'mileMarkerOnRoute': 10.5,
            'severity': 'low',
            'isRoadClosed': false,
          },
          {
            'id': 'slow-1',
            'type': 'slowdown',
            'title': 'Traffic Delay',
            'description': 'Congestion',
            'location': 'I-70 W',
            'latitude': 39.85,
            'longitude': -83.70,
            'distanceFromRouteMiles': 0.01,
            'mileMarkerOnRoute': 20.0,
            'severity': 'medium',
            'isRoadClosed': false,
          },
          {
            'id': 'const-1',
            'type': 'construction',
            'title': 'Lane Closure',
            'description': 'Paving',
            'location': 'I-70 W',
            'latitude': 39.80,
            'longitude': -84.00,
            'distanceFromRouteMiles': 0.03,
            'mileMarkerOnRoute': 35.0,
            'severity': 'medium',
            'isRoadClosed': false,
          },
        ],
      };

      final result = CommuteCheckResult.fromJson(json);

      expect(result.success, isTrue);
      expect(result.isClear, isFalse);
      expect(result.status, equals('moderate_hazards'));
      expect(result.corridorBufferMiles, equals(0.31));
      expect(result.summary.totalHazards, equals(3));
      expect(result.summary.incidentsCount, equals(1));
      expect(result.summary.slowdownsCount, equals(1));
      expect(result.summary.constructionCount, equals(1));
      expect(result.hazards.length, equals(3));
      expect(result.incidents.length, equals(1));
      expect(result.slowdowns.length, equals(1));
      expect(result.construction.length, equals(1));
      expect(result.hasHazards, isTrue);
      expect(result.route.totalDistanceMiles, equals(45.2));
    });

    test('toJson generates complete output correctly', () {
      final jsonInput = {
        'success': true,
        'isClear': true,
        'status': 'clear',
        'summary': {
          'totalHazards': 0,
          'incidentsCount': 0,
          'slowdownsCount': 0,
          'constructionCount': 0,
          'message': 'Your route is completely clear!',
        },
        'route': {
          'totalDistanceMiles': 10.0,
          'totalDurationSeconds': 600,
          'start': {'lat': 40.0, 'lon': -83.0},
          'end': {'lat': 40.1, 'lon': -83.1},
          'isEstimatedRoute': false,
          'geometry': {
            'type': 'LineString',
            'coordinates': [
              [-83.0, 40.0],
              [-83.1, 40.1],
            ],
          },
        },
        'corridorBufferMiles': 0.31,
        'hazards': <dynamic>[],
      };

      final result = CommuteCheckResult.fromJson(jsonInput);
      final jsonOutput = result.toJson();

      expect(jsonOutput['isClear'], isTrue);
      expect(jsonOutput['status'], equals('clear'));
      expect(jsonOutput['corridorBufferMiles'], equals(0.31));
      expect(result.hasHazards, isFalse);
    });
  });
}
