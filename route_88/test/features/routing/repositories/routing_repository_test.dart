import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  group('RoutingRepository', () {
    late RoutingRepository repository;
    late MockApiClient mockApiClient;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();

      when(() => mockApiClient.dio).thenReturn(mockDio);
      repository = RoutingRepository(apiClient: mockApiClient);
    });

    group('searchPlaces', () {
      test('returns list of places on success', () async {
        final mockResponseData = {
          'success': true,
          'results': [
            {
              'id': 100,
              'displayName': 'Columbus, OH',
              'lat': 39.96,
              'lon': -83.00,
              'street': 'Broad St',
              'city': 'Columbus',
            },
          ],
        };

        when(
          () => mockDio.get<Map<String, dynamic>>(
            '/route/autocomplete',
            queryParameters: {'query': 'Columbus'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/route/autocomplete'),
            data: mockResponseData,
            statusCode: 200,
          ),
        );

        final result = await repository.searchPlaces('Columbus');

        expect(result.length, equals(1));
        expect(result.first.id, equals('100'));
        expect(result.first.displayName, equals('Columbus, OH'));
        expect(result.first.coordinate.lat, equals(39.96));
        expect(result.first.coordinate.lng, equals(-83.00));
      });

      test('returns empty list if response data is missing results', () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(
            '/route/autocomplete',
            queryParameters: {'query': 'Unknown'},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/route/autocomplete'),
            data: {'success': true, 'results': null},
            statusCode: 200,
          ),
        );

        final result = await repository.searchPlaces('Unknown');
        expect(result, isEmpty);
      });

      test('throws Exception on DioException', () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(
            '/route/autocomplete',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/route/autocomplete'),
            message: 'Server timeout',
          ),
        );

        expect(
          () => repository.searchPlaces('Columbus'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to search places'),
            ),
          ),
        );
      });
    });

    group('getRoute', () {
      test('returns RouteResult on success', () async {
        final mockRouteData = {
          'success': true,
          'route': {
            'distance': 2500.0,
            'duration': 300.0,
            'geometry': {
              'type': 'LineString',
              'coordinates': [
                [-83.00, 39.96],
                [-83.01, 39.97],
              ],
            },
            'steps': [
              {
                'instruction': 'Head north',
                'distancemeters': 1000.0,
                'durationSeconds': 120.0,
                'location': {'lat': 39.96, 'lon': -83.00},
                'manueverType': 'depart',
              },
            ],
          },
        };

        const start = Coordinate(lat: 39.96, lng: -83);
        const end = Coordinate(lat: 39.97, lng: -83.01);

        when(
          () => mockDio.get<Map<String, dynamic>>(
            '/route/calculate',
            queryParameters: {
              'startLat': 39.96,
              'startLon': -83.00,
              'endLat': 39.97,
              'endLon': -83.01,
            },
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/route/calculate'),
            data: mockRouteData,
            statusCode: 200,
          ),
        );

        final result = await repository.getRoute(start, end);

        expect(result.distanceMeters, equals(2500));
        expect(result.durationSeconds, equals(300));
        expect(result.coordinates.length, equals(2));
        expect(result.steps.length, equals(1));
      });

      test('throws Exception if route data is null or empty', () async {
        const start = Coordinate(lat: 39.96, lng: -83);
        const end = Coordinate(lat: 39.97, lng: -83.01);

        when(
          () => mockDio.get<Map<String, dynamic>>(
            '/route/calculate',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/route/calculate'),
            data: {'success': false},
            statusCode: 200,
          ),
        );

        expect(
          () => repository.getRoute(start, end),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Empty or failed response'),
            ),
          ),
        );
      });

      test('throws Exception on DioException with error message from backend',
          () async {
        const start = Coordinate(lat: 39.96, lng: -83);
        const end = Coordinate(lat: 39.97, lng: -83.01);

        when(
          () => mockDio.get<Map<String, dynamic>>(
            '/route/calculate',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/route/calculate'),
            response: Response(
              requestOptions: RequestOptions(path: '/route/calculate'),
              data: {'error': 'No route found'},
              statusCode: 400,
            ),
          ),
        );

        expect(
          () => repository.getRoute(start, end),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('No route found'),
            ),
          ),
        );
      });
    });
  });
}
