import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/place.dart';

void main() {
  group('Place', () {
    test('fromJson parses standard Nominatim response correctly', () {
      final json = {
        'id': 12345,
        'displayName': '123 Main St, Columbus, OH',
        'street': 'Main St',
        'city': 'Columbus',
        'lat': 39.9612,
        'lon': -83.0019,
      };

      final place = Place.fromJson(json);

      expect(place.id, equals('12345'));
      expect(place.displayName, equals('123 Main St, Columbus, OH'));
      expect(place.street, equals('Main St'));
      expect(place.city, equals('Columbus'));
      expect(place.coordinate.lat, equals(39.9612));
      expect(place.coordinate.lng, equals(-83.0019));
    });

    test('fromJson handles null and missing optional fields', () {
      final json = <String, dynamic>{
        'lat': 40.0,
        'lon': -82.0,
      };

      final place = Place.fromJson(json);

      expect(place.id, equals(''));
      expect(place.displayName, equals('Unknown'));
      expect(place.street, isNull);
      expect(place.city, isNull);
      expect(place.coordinate.lat, equals(40.0));
      expect(place.coordinate.lng, equals(-82.0));
    });

    test('fromJson handles nested coordinate map', () {
      final json = {
        'id': 'p1',
        'displayName': 'Test Place',
        'coordinate': {'lat': 42.0, 'lng': -84.0},
      };

      final place = Place.fromJson(json);
      expect(place.coordinate.lat, equals(42.0));
      expect(place.coordinate.lng, equals(-84.0));
    });

    test('toJson produces correct structure', () {
      const place = Place(
        id: '1',
        displayName: 'Test',
        street: 'Oak St',
        city: 'Dayton',
        coordinate: Coordinate(lat: 39.75, lng: -84.19),
      );

      final json = place.toJson();

      expect(json['id'], equals('1'));
      expect(json['displayName'], equals('Test'));
      expect(json['street'], equals('Oak St'));
      expect(json['city'], equals('Dayton'));
      expect(json['lat'], equals(39.75));
      expect(json['lon'], equals(-84.19));
    });

    test('copyWith updates specified fields', () {
      const place = Place(
        id: '1',
        displayName: 'Old Name',
        coordinate: Coordinate(lat: 10, lng: 20),
      );

      final updated = place.copyWith(displayName: 'New Name');

      expect(updated.displayName, equals('New Name'));
      expect(updated.id, equals('1'));
    });

    test('props handles equatable comparison', () {
      const p1 = Place(
        id: '1',
        displayName: 'Place',
        coordinate: Coordinate(lat: 1, lng: 2),
      );
      const p2 = Place(
        id: '1',
        displayName: 'Place',
        coordinate: Coordinate(lat: 1, lng: 2),
      );

      expect(p1, equals(p2));
    });
  });
}
