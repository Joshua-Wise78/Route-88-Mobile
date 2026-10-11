import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

void main() {
  group('Coordinate', () {
    test('fromJson works with lat and lng', () {
      final json = {'lat': 39.9612, 'lng': -83.0019};
      final coord = Coordinate.fromJson(json);

      expect(coord.lat, equals(39.9612));
      expect(coord.lng, equals(-83.0019));
    });

    test('fromJson works with lat and lon', () {
      final json = {'lat': 41.5055, 'lon': -81.6934};
      final coord = Coordinate.fromJson(json);

      expect(coord.lat, equals(41.5055));
      expect(coord.lng, equals(-81.6934));
    });

    test('formJson backward compatibility constructor works', () {
      final json = {'lat': 40, 'lng': -82};
      // Test the deprecated fallback constructor
      // ignore: deprecated_member_use_from_same_package
      final coord = Coordinate.formJson(json);

      expect(coord.lat, equals(40));
      expect(coord.lng, equals(-82));
    });

    test('toJson returns expected map', () {
      const coord = Coordinate(lat: 39.9612, lng: -83.0019);
      final json = coord.toJson();

      expect(json, equals({'lat': 39.9612, 'lng': -83.0019}));
    });

    test('toUrlValue returns lng,lat string', () {
      const coord = Coordinate(lat: 39.9612, lng: -83.0019);
      expect(coord.toUrlValue(), equals('-83.0019,39.9612'));
    });

    test('copyWith updates values', () {
      const coord = Coordinate(lat: 10, lng: 20);
      final updated = coord.copyWith(lat: 15);

      expect(updated.lat, equals(15));
      expect(updated.lng, equals(20));
    });

    test('props contains lat and lng for equality', () {
      const coord1 = Coordinate(lat: 10, lng: 20);
      const coord2 = Coordinate(lat: 10, lng: 20);
      const coord3 = Coordinate(lat: 10, lng: 25);

      expect(coord1, equals(coord2));
      expect(coord1 == coord3, isFalse);
    });
  });
}
