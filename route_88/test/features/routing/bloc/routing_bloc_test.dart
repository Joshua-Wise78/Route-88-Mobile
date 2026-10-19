import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/features/routing/bloc/routing_bloc.dart';
import 'package:route_88/features/routing/bloc/routing_event.dart';
import 'package:route_88/features/routing/bloc/routing_state.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/place.dart';
import 'package:route_88/features/routing/models/route_result.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';

class MockRoutingRepository extends Mock implements RoutingRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Coordinate(lat: 0, lng: 0));
  });

  group('RoutingBloc', () {
    late MockRoutingRepository mockRepository;

    setUp(() {
      mockRepository = MockRoutingRepository();
    });

    test('initial state is RoutingInitial', () {
      final bloc = RoutingBloc(routingRepository: mockRepository);
      expect(bloc.state, equals(const RoutingInitial()));
    });

    group('AutocompleteAddressRequested', () {
      const testPlace = Place(
        id: '1',
        displayName: 'Broad St, Columbus, OH',
        coordinate: Coordinate(lat: 39.96, lng: -83),
      );

      blocTest<RoutingBloc, RoutingState>(
        'emits [AutoCompleteLoaded] with empty list when query is too short',
        build: () => RoutingBloc(routingRepository: mockRepository),
        act: (bloc) =>
            bloc.add(const AutocompleteAddressRequested(address: 'a')),
        expect: () => [
          isA<AutoCompleteLoaded>().having(
            (state) => state.places,
            'places',
            isEmpty,
          ),
        ],
        verify: (_) {
          verifyNever(() => mockRepository.searchPlaces(any()));
        },
      );

      blocTest<RoutingBloc, RoutingState>(
        'emits [AutoCompleteLoading, AutoCompleteLoaded] on successful search',
        build: () {
          when(() => mockRepository.searchPlaces('Broad'))
              .thenAnswer((_) async => [testPlace]);
          return RoutingBloc(routingRepository: mockRepository);
        },
        act: (bloc) =>
            bloc.add(const AutocompleteAddressRequested(address: 'Broad')),
        expect: () => [
          isA<AutoCompleteLoading>(),
          isA<AutoCompleteLoaded>().having(
            (state) => state.places.first.displayName,
            'displayName',
            'Broad St, Columbus, OH',
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.searchPlaces('Broad')).called(1);
        },
      );

      blocTest<RoutingBloc, RoutingState>(
        'emits [AutoCompleteLoading, AutoCompleteError] when search fails',
        build: () {
          when(() => mockRepository.searchPlaces(any()))
              .thenThrow(Exception('Network error'));
          return RoutingBloc(routingRepository: mockRepository);
        },
        act: (bloc) =>
            bloc.add(const AutocompleteAddressRequested(address: 'Broad')),
        expect: () => [
          isA<AutoCompleteLoading>(),
          isA<AutoCompleteError>().having(
            (state) => state.message,
            'message',
            contains('Network error'),
          ),
        ],
      );
    });

    group('CalculatedRouteRequested', () {
      const mockResult = RouteResult(
        coordinates: [
          Coordinate(lat: 39.96, lng: -83),
          Coordinate(lat: 39.97, lng: -83.01),
        ],
        distanceMeters: 1200,
        durationSeconds: 150,
        steps: [],
      );

      blocTest<RoutingBloc, RoutingState>(
        'emits [RouteCalculationError] when coordinates are missing',
        build: () => RoutingBloc(routingRepository: mockRepository),
        act: (bloc) => bloc.add(
          const CalculatedRouteRequested(
            startLat: 39.96,
            startLong: -83,
          ),
        ),
        expect: () => [
          isA<RouteCalculationError>().having(
            (state) => state.message,
            'message',
            contains('Start and end coordinates are required'),
          ),
        ],
      );

      blocTest<RoutingBloc, RoutingState>(
        'emits [RouteCalculationLoading, RouteCalculated] on success with lat/lng',
        build: () {
          when(
            () => mockRepository.getRoute(
              any(),
              any(),
            ),
          ).thenAnswer((_) async => mockResult);
          return RoutingBloc(routingRepository: mockRepository);
        },
        act: (bloc) => bloc.add(
          const CalculatedRouteRequested(
            startLat: 39.96,
            startLong: -83,
            endLat: 39.97,
            endLong: -83.01,
          ),
        ),
        expect: () => [
          isA<RouteCalculationLoading>(),
          isA<RouteCalculated>().having(
            (state) => state.route.distanceMeters,
            'distanceMeters',
            1200,
          ),
        ],
      );

      blocTest<RoutingBloc, RoutingState>(
        'emits calculated state when using Coordinate objects',
        build: () {
          when(
            () => mockRepository.getRoute(
              any(),
              any(),
            ),
          ).thenAnswer((_) async => mockResult);
          return RoutingBloc(routingRepository: mockRepository);
        },
        act: (bloc) => bloc.add(
          const CalculatedRouteRequested(
            start: Coordinate(lat: 39.96, lng: -83),
            end: Coordinate(lat: 39.97, lng: -83.01),
          ),
        ),
        expect: () => [
          isA<RouteCalculationLoading>(),
          isA<RouteCalculated>(),
        ],
      );

      blocTest<RoutingBloc, RoutingState>(
        'emits [RouteCalculationLoading, RouteCalculationError] on error',
        build: () {
          when(
            () => mockRepository.getRoute(
              any(),
              any(),
            ),
          ).thenThrow(Exception('Route service unavailable'));
          return RoutingBloc(routingRepository: mockRepository);
        },
        act: (bloc) => bloc.add(
          const CalculatedRouteRequested(
            startLat: 39.96,
            startLong: -83,
            endLat: 39.97,
            endLong: -83.01,
          ),
        ),
        expect: () => [
          isA<RouteCalculationLoading>(),
          isA<RouteCalculationError>().having(
            (state) => state.message,
            'message',
            contains('Route service unavailable'),
          ),
        ],
      );
    });

    group('Clear events', () {
      const mockResult = RouteResult(
        coordinates: [],
        distanceMeters: 500,
        durationSeconds: 60,
        steps: [],
      );
      const testPlace = Place(
        id: '1',
        displayName: 'Place 1',
        coordinate: Coordinate(lat: 1, lng: 1),
      );

      blocTest<RoutingBloc, RoutingState>(
        'ClearRouteRequested resets to RoutingInitial when places are empty',
        build: () => RoutingBloc(routingRepository: mockRepository),
        seed: () => const RouteCalculated(route: mockResult),
        act: (bloc) => bloc.add(const ClearRouteRequested()),
        expect: () => [
          const RoutingInitial(),
        ],
      );

      blocTest<RoutingBloc, RoutingState>(
        'ClearRouteRequested preserves places if present',
        build: () => RoutingBloc(routingRepository: mockRepository),
        seed: () => const RouteCalculated(
          route: mockResult,
          places: [testPlace],
        ),
        act: (bloc) => bloc.add(const ClearRouteRequested()),
        expect: () => [
          isA<AutoCompleteLoaded>().having(
            (state) => state.places.length,
            'length',
            1,
          ),
        ],
      );

      blocTest<RoutingBloc, RoutingState>(
        'ClearAutocompleteRequested resets to initial when route is null',
        build: () => RoutingBloc(routingRepository: mockRepository),
        seed: () => const AutoCompleteLoaded(places: [testPlace]),
        act: (bloc) => bloc.add(const ClearAutocompleteRequested()),
        expect: () => [
          const RoutingInitial(),
        ],
      );

      blocTest<RoutingBloc, RoutingState>(
        'ClearAutocompleteRequested preserves route if present',
        build: () => RoutingBloc(routingRepository: mockRepository),
        seed: () => const AutoCompleteLoaded(
          places: [testPlace],
          route: mockResult,
        ),
        act: (bloc) => bloc.add(const ClearAutocompleteRequested()),
        expect: () => [
          isA<RouteCalculated>().having(
            (state) => state.route,
            'route',
            mockResult,
          ),
        ],
      );
    });
  });
}
