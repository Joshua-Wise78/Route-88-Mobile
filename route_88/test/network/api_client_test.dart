import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/core/network/api_client.dart';

void main() {
  group('ApiClient Network Tests', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient();
    });

    test('should fetch incidents and return 200 OK', () async {
      // Act
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/incidents',
      );

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.data, isNotNull);
      
      final results = response.data!['results'] as List<dynamic>?;
      expect(results, isNotNull);
      expect(results, isNotEmpty, reason: 'Expected at least one incident from OHGO');
      
      // Verify structure of the first incident
      final firstIncident = results!.first as Map<String, dynamic>;
      expect(firstIncident.containsKey('id'), isTrue);
      expect(firstIncident.containsKey('location'), isTrue);
      expect(firstIncident.containsKey('description'), isTrue);
    });

    test('should throw 401 Unauthorized if API key is invalid', () async {
      // Create a client with a deliberately broken token
      final badClient = Dio(
        BaseOptions(
          baseUrl: 'http://wise-server.tail904182.ts.net:3333',
        ),
      )..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              options.headers['Authorization'] = 'Bearer BAD_TOKEN';
              return handler.next(options);
            },
          ),
        );

      // Assert that a DioException is thrown with a 401 status code
      expect(
        () => badClient.get<dynamic>('/api/mobile/incidents'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });
  });
}
