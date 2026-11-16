import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/routing/models/route_hazard.dart';

void main() {
  group('RouteHazard', () {
    test('fromJson parses full hazard payload correctly', () {
      final json = {
        'id': 'inc-999',
        'type': 'incident',
        'title': 'Crash on I-71 S',
        'description': 'Two vehicle collision blocking right lane',
        'location': 'I-71 Southbound at Exit 104',
        'latitude': 39.9550,
        'longitude': -83.0030,
        'distanceFromRouteMiles': 0.05,
        'mileMarkerOnRoute': 14.2,
        'severity': 'high',
        'isRoadClosed': false,
        'direction': 'Southbound',
        'routeName': 'I-71',
      };

      final hazard = RouteHazard.fromJson(json);

      expect(hazard.id, equals('inc-999'));
      expect(hazard.type, equals('incident'));
      expect(hazard.title, equals('Crash on I-71 S'));
      expect(hazard.description, contains('collision'));
      expect(hazard.location, equals('I-71 Southbound at Exit 104'));
      expect(hazard.latitude, equals(39.9550));
      expect(hazard.longitude, equals(-83.0030));
      expect(hazard.distanceFromRouteMiles, equals(0.05));
      expect(hazard.mileMarkerOnRoute, equals(14.2));
      expect(hazard.severity, equals('high'));
      expect(hazard.isRoadClosed, isFalse);
      expect(hazard.direction, equals('Southbound'));
      expect(hazard.routeName, equals('I-71'));
      expect(hazard.isIncident, isTrue);
      expect(hazard.isSlowdown, isFalse);
      expect(hazard.isConstruction, isFalse);
      expect(hazard.coordinate.lat, equals(39.9550));
      expect(hazard.coordinate.lng, equals(-83.0030));
    });

    test('fromJson handles fallback defaults when fields are missing', () {
      final json = <String, dynamic>{};
      final hazard = RouteHazard.fromJson(json);

      expect(hazard.id, isEmpty);
      expect(hazard.type, equals('incident'));
      expect(hazard.title, equals('Hazard'));
      expect(hazard.latitude, equals(0.0));
      expect(hazard.longitude, equals(0.0));
      expect(hazard.distanceFromRouteMiles, equals(0.0));
      expect(hazard.mileMarkerOnRoute, equals(0.0));
      expect(hazard.severity, equals('medium'));
      expect(hazard.isRoadClosed, isFalse);
      expect(hazard.direction, isNull);
      expect(hazard.routeName, isNull);
    });

    test('toJson produces correct map structure', () {
      const hazard = RouteHazard(
        id: 'slow-123',
        type: 'slowdown',
        title: 'Heavy Traffic',
        description: 'Speeds under 25mph',
        location: 'I-70 East',
        latitude: 39.96,
        longitude: -83.01,
        distanceFromRouteMiles: 0.1,
        mileMarkerOnRoute: 5.5,
        severity: 'medium',
        isRoadClosed: false,
        direction: 'Eastbound',
        routeName: 'I-70',
      );

      final json = hazard.toJson();

      expect(json['id'], equals('slow-123'));
      expect(json['type'], equals('slowdown'));
      expect(json['title'], equals('Heavy Traffic'));
      expect(json['latitude'], equals(39.96));
      expect(json['longitude'], equals(-83.01));
      expect(json['distanceFromRouteMiles'], equals(0.1));
      expect(json['mileMarkerOnRoute'], equals(5.5));
      expect(json['direction'], equals('Eastbound'));
      expect(json['routeName'], equals('I-70'));
    });

    test('props handles equatable comparison', () {
      const h1 = RouteHazard(
        id: '1',
        type: 'incident',
        title: 'T',
        description: 'D',
        location: 'L',
        latitude: 1,
        longitude: 2,
        distanceFromRouteMiles: 0.1,
        mileMarkerOnRoute: 2.5,
        severity: 'low',
        isRoadClosed: false,
      );
      const h2 = RouteHazard(
        id: '1',
        type: 'incident',
        title: 'T',
        description: 'D',
        location: 'L',
        latitude: 1,
        longitude: 2,
        distanceFromRouteMiles: 0.1,
        mileMarkerOnRoute: 2.5,
        severity: 'low',
        isRoadClosed: false,
      );

      expect(h1, equals(h2));
    });
  });
}
