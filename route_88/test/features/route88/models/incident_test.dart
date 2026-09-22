import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/route88/models/incident.dart';

void main() {
  group('Incident', () {
    test('fromJson works correctly', () {
      final json = {
        'id': '123',
        'latitude': 35.0,
        'longitude': -80.0,
        'location': 'Main St',
        'description': 'Accident',
        'category': 'Crash',
        'direction': 'N',
        'routeName': 'I-88',
        'roadStatus': 'Closed',
        'link': {'href': 'https://example.com'},
        'roadClosureDetail': {
          'closureStartLocation': [35.0, -80.0],
          'closureEndLocation': [35.1, -80.1],
          'polyline': [
            [35.0, -80.0],
            [35.1, -80.1],
          ],
        },
      };

      final incident = Incident.fromJson(json);

      expect(incident.id, '123');
      expect(incident.latitude, 35.0);
      expect(incident.longitude, -80.0);
      expect(incident.location, 'Main St');
      expect(incident.description, 'Accident');
      expect(incident.category, 'Crash');
      expect(incident.direction, 'N');
      expect(incident.routeName, 'I-88');
      expect(incident.roadStatus, 'Closed');
      expect(incident.link?.href, 'https://example.com');

      expect(incident.roadClosureDetail?.closureStartLocation, [35.0, -80.0]);
      expect(incident.roadClosureDetail?.closureEndLocation, [35.1, -80.1]);
      expect(incident.roadClosureDetail?.polyline, [
        [35.0, -80.0],
        [35.1, -80.1],
      ]);
    });

    test('fromJson handles nulls and missing fields gracefully', () {
      final json = <String, dynamic>{};
      final incident = Incident.fromJson(json);

      expect(incident.id, '');
      expect(incident.latitude, 0.0);
      expect(incident.longitude, 0.0);
      expect(incident.location, isNull);
      expect(incident.link, isNull);
      expect(incident.roadClosureDetail, isNull);
    });
  });

  group('RoadClosureDetail', () {
    test('fromJson handles empty fields', () {
      final json = <String, dynamic>{};
      final detail = RoadClosureDetail.fromJson(json);

      expect(detail.closureStartLocation, isEmpty);
      expect(detail.closureEndLocation, isEmpty);
      expect(detail.polyline, isEmpty);
    });
  });
}
