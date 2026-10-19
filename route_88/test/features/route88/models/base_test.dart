import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/features/route88/models/base.dart';

void main() {
  group('Link', () {
    test('fromJson works correctly', () {
      final json = {'href': '/link', 'rel': 'self', 'method': 'GET'};
      final link = Link.fromJson(json);

      expect(link.href, '/link');
      expect(link.rel, 'self');
      expect(link.method, 'GET');
    });
  });

  group('Base', () {
    test('fromJson works correctly', () {
      final json = {
        'id': '1',
        'latitude': 35.0,
        'longitude': -80.0,
        'location': 'Main St',
        'link': {'href': '/api/1', 'rel': 'self'},
      };

      final baseModel = Base.fromJson(json);

      expect(baseModel.id, '1');
      expect(baseModel.latitude, 35.0);
      expect(baseModel.location, 'Main St');
      expect(baseModel.link?.href, '/api/1');
    });

    test('fromJson handles nulls gracefully', () {
      final json = <String, dynamic>{};
      final baseModel = Base.fromJson(json);

      expect(baseModel.id, '');
      expect(baseModel.latitude, 0.0);
      expect(baseModel.longitude, 0.0);
      expect(baseModel.link, isNull);
    });
  });
}
