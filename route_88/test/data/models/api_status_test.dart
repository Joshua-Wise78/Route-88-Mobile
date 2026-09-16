import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/data/models/api_status.dart';

void main() {
  group('ApiStatus', () {
    test('fromJson works correctly', () {
      final json = {'status': 'up', 'for': 'all'};
      final status = ApiStatus.fromJson(json);

      expect(status.status, 'up');
      expect(status.forTarget, 'all');
    });
  });
}
