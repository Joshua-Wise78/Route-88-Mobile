import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/route88/models/slowdowns.dart';

void main() {
  group('Slowdown', () {
    test('fromJson works correctly', () {
      final json = {
        'id': '123',
        'latitude': 35.0,
        'longitude': -80.0,
        'location': 'Main St',
        'normalMPH': 65,
        'currentMPH': 45,
      };

      final slowdown = Slowdown.fromJson(json);

      expect(slowdown.id, '123');
      expect(slowdown.latitude, 35.0);
      expect(slowdown.longitude, -80.0);
      expect(slowdown.location, 'Main St');
      expect(slowdown.normalMPH, 65);
      expect(slowdown.currentMPH, 45);
    });

    test('fromJson handles nulls gracefully', () {
      final json = <String, dynamic>{};
      final slowdown = Slowdown.fromJson(json);

      expect(slowdown.id, '');
      expect(slowdown.latitude, 0.0);
      expect(slowdown.longitude, 0.0);
      expect(slowdown.normalMPH, isNull);
      expect(slowdown.currentMPH, isNull);
    });
  });
}
