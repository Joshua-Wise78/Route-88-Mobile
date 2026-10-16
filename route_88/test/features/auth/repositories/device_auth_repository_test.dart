import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/auth/repositories/device_auth_repository.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockDio extends Mock implements Dio {}

void main() {
  group('DeviceAuthRepository', () {
    late DeviceAuthRepository repository;
    late MockApiClient mockApiClient;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();

      when(() => mockApiClient.dio).thenReturn(mockDio);
      repository = DeviceAuthRepository(apiClient: mockApiClient);
    });

    test('registerDevice returns true on success', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(), 
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/register'),
                data: {'success': true},
                statusCode: 200,
              ));

      final result = await repository.registerDevice('device_123');

      expect(result, isTrue);
      verify(() => mockDio.post<Map<String, dynamic>>(
        '/register',
        data: {'deviceId': 'device_123'},
      )).called(1);
    });
  });
}
