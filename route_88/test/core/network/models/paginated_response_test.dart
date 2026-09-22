import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/core/network/models/paginated_response.dart';

void main() {
  group('PaginatedResponse', () {
    test('fromJson works correctly', () {
      final json = {
        'totalPageCount': 2,
        'totalResultCount': 15,
        'results': [
          {'id': 1},
          {'id': 2},
        ],
      };

      final response = PaginatedResponse<int>.fromJson(
        json,
        (data) => data['id'] as int,
      );

      expect(response.totalPageCount, 2);
      expect(response.totalResultCount, 15);
      expect(response.results.length, 2);
      expect(response.results, [1, 2]);
    });

    test('fromJson handles nulls gracefully', () {
      final json = <String, dynamic>{};
      final response = PaginatedResponse<int>.fromJson(json, (data) => 0);

      expect(response.totalPageCount, 0);
      expect(response.totalResultCount, 0);
      expect(response.results, isEmpty);
    });
  });
}
