import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/route88/repositories/construction_repository.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockDio extends Mock implements Dio {}

void main() {
  group('ConstructionRepository', () {
    late ConstructionRepository repository;
    late MockApiClient mockApiClient;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();

      when(() => mockApiClient.dio).thenReturn(mockDio);
      repository = ConstructionRepository(apiClient: mockApiClient);
    });

    test('returns list of construction on successful request', () async {
      final mockResponseData = {
        'results': [
          {'id': '1', 'latitude': 35.0, 'longitude': -80.0}
        ]
      };

      when(() => mockDio.get<Map<String, dynamic>>(
            any(), 
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/construction'),
                data: mockResponseData,
                statusCode: 200,
              ));

      final result = await repository.getConstruction(latitude: 35, longitude: -80, radiusMiles: 10);

      expect(result.length, 1);
      expect(result.first.id, '1');
      
      verify(() => mockDio.get<Map<String, dynamic>>(
        '/construction',
        queryParameters: {'latitude': 35.0, 'longitude': -80.0, 'radiusMiles': 10.0},
      )).called(1);
    });
  });
}
