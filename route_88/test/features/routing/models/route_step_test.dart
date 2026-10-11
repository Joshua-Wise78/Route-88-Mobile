import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/route_step.dart';

void main() {
  group('RouteStep', () {
    test('fromJson parses standard turnByTurn step from backend correctly',
        () {
      final json = {
        'instruction': 'turn right onto High St',
        'distancemeters': 450.5,
        'durationSeconds': 55.2,
        'location': {'lat': 39.96, 'lon': -83.00},
        'manueverType': 'turn',
        'manueverModifier': 'right',
      };

      final step = RouteStep.fromJson(json);

      expect(step.instruction, equals('turn right onto High St'));
      expect(step.distanceMeters, equals(450.5));
      expect(step.durationSeconds, equals(55.2));
      expect(step.location.lat, equals(39.96));
      expect(step.location.lng, equals(-83.00));
      expect(step.maneuverType, equals('turn'));
      expect(step.maneuverModifier, equals('right'));
    });

    test('fromJson handles alternative key spellings and defaults', () {
      final json = {
        'instruction': 'straight',
        'distanceMeters': 100,
        'duration': 20,
        'location': [-83.0, 39.9],
        'maneuverType': 'continue',
      };

      final step = RouteStep.fromJson(json);

      expect(step.distanceMeters, equals(100));
      expect(step.durationSeconds, equals(20));
      expect(step.location.lat, equals(39.9));
      expect(step.location.lng, equals(-83.0));
      expect(step.maneuverType, equals('continue'));
      expect(step.maneuverModifier, isNull);
    });

    test('toJson outputs expected structure', () {
      const step = RouteStep(
        instruction: 'Arrive at destination',
        distanceMeters: 0,
        durationSeconds: 0,
        location: Coordinate(lat: 39.9, lng: -83),
        maneuverType: 'arrive',
      );

      final json = step.toJson();

      expect(json['instruction'], equals('Arrive at destination'));
      expect(json['distancemeters'], equals(0));
      expect(json['durationSeconds'], equals(0));
      expect(json['location'], equals({'lat': 39.9, 'lon': -83}));
      expect(json['manueverType'], equals('arrive'));
    });

    test('copyWith updates properties', () {
      const step = RouteStep(
        instruction: 'turn left',
        distanceMeters: 100,
        durationSeconds: 10,
        location: Coordinate(lat: 1, lng: 1),
        maneuverType: 'turn',
      );

      final updated = step.copyWith(instruction: 'turn right');
      expect(updated.instruction, equals('turn right'));
      expect(updated.distanceMeters, equals(100));
    });

    test('props handles equality', () {
      const s1 = RouteStep(
        instruction: 'turn',
        distanceMeters: 10,
        durationSeconds: 5,
        location: Coordinate(lat: 1, lng: 1),
        maneuverType: 'turn',
      );
      const s2 = RouteStep(
        instruction: 'turn',
        distanceMeters: 10,
        durationSeconds: 5,
        location: Coordinate(lat: 1, lng: 1),
        maneuverType: 'turn',
      );

      expect(s1, equals(s2));
    });
  });
}
