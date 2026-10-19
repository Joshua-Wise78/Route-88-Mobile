import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/route88/repositories/incident_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  group('IncidentRepository', () {
    late IncidentRepository repository;
    late MockApiClient mockApiClient;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();

      when(() => mockApiClient.dio).thenReturn(mockDio);
      repository = IncidentRepository(apiClient: mockApiClient);
    });

    test('return list of incidents', () async {
      final mockResponseData = {
        'results': [
          {'id': '1', 'latitude': 35.0, 'longitude': -80},
        ],
      };

      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/incidents'),
          data: mockResponseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getIncidents(
        latitude: 35,
        longitude: -80,
        radiusMiles: 10,
      );

      expect(result.length, 1);
      expect(result.first.id, '1');

      verify(
        () => mockDio.get<Map<String, dynamic>>(
          '/incidents',
          queryParameters: {
            'latitude': 35.0,
            'longitude': -80.0,
            'radiusMiles': 10.0,
          },
        ),
      ).called(1);
    });
  });
}
