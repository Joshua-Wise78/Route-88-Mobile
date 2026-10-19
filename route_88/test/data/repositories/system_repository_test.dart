import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/data/repositories/system_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  group('SystemRepository', () {
    late SystemRepository repository;
    late MockApiClient mockApiClient;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();

      when(() => mockApiClient.dio).thenReturn(mockDio);
      repository = SystemRepository(apiClient: mockApiClient);
    });

    test('getStatus returns ApiStatus', () async {
      when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/status'),
          data: {'status': 'up', 'for': 'all'},
          statusCode: 200,
        ),
      );

      final result = await repository.getStatus();

      expect(result.status, 'up');
      verify(() => mockDio.get<Map<String, dynamic>>('/status')).called(1);
    });
  });
}
