import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/route88/models/construction.dart';

void main() {
  group('Construction', () {
    test('fromJson works correctly', () {
      final json = {
        'id': '123',
        'latitude': 35.0,
        'longitude': -80.0,
        'status': 'Active',
        'district': 'District 1',
        'startDate': '2023-01-01',
        'endDate': '2023-12-31',
        'location': 'Main St',
        'workZone': {
          'description': 'Zone A',
          'startLocation': [35.0, -80.0],
          'endLocation': [35.1, -80.1],
          'polyline': [
            [35.0, -80.0],
            [35.1, -80.1],
          ],
        },
      };

      final construction = Construction.fromJson(json);

      expect(construction.id, '123');
      expect(construction.latitude, 35.0);
      expect(construction.status, 'Active');
      expect(construction.district, 'District 1');
      expect(construction.startDate, '2023-01-01');
      expect(construction.endDate, '2023-12-31');
      expect(construction.location, 'Main St');
      expect(construction.workZone?.description, 'Zone A');
      expect(construction.workZone?.startLocation, [35.0, -80.0]);
    });

    test('fromJson handles empty fields', () {
      final json = <String, dynamic>{};
      final construction = Construction.fromJson(json);

      expect(construction.id, '');
      expect(construction.latitude, 0.0);
      expect(construction.status, '');
      expect(construction.workZone, isNull);
    });
  });

  group('ConstructionDetour', () {
    test('fromJson works correctly', () {
      final json = {
        'name': 'Detour 1',
        'description': 'Take alt route',
        'startDate': '2023-01-01',
        'endDate': '2023-12-31',
        'detourRoute': {
          'roadName': 'Alt St',
          'startLocation': [35.0, -80.0],
        },
      };

      final detour = ConstructionDetour.fromJson(json);

      expect(detour.name, 'Detour 1');
      expect(detour.detourRoute?.roadName, 'Alt St');
      expect(detour.detourRoute?.startLocation, [35.0, -80.0]);
    });
  });
}
