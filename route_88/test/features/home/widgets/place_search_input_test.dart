import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/features/home/widgets/place_search_input.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/place.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';

class MockRoutingRepository extends Mock implements RoutingRepository {}

void main() {
  group('PlaceSearchInput', () {
    late MockRoutingRepository mockRepository;
    late TextEditingController controller;

    setUp(() {
      mockRepository = MockRoutingRepository();
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders hint text and prefix icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceSearchInput(
              routingRepository: mockRepository,
              controller: controller,
              hintText: 'Search start location...',
              prefixIcon: Icons.trip_origin,
              iconColor: Colors.green,
              onPlaceSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Search start location...'), findsOneWidget);
      expect(find.byIcon(Icons.trip_origin), findsOneWidget);
    });

    testWidgets('searches places and selects a suggestion', (tester) async {
      const mockPlaces = [
        Place(
          id: '1',
          displayName: 'Columbus, OH, USA',
          coordinate: Coordinate(lat: 39.9612, lng: -83.0019),
        ),
      ];

      when(() => mockRepository.searchPlaces('Columbus'))
          .thenAnswer((_) async => mockPlaces);

      Place? selectedPlace;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceSearchInput(
              routingRepository: mockRepository,
              controller: controller,
              hintText: 'Search location...',
              prefixIcon: Icons.search,
              iconColor: Colors.blue,
              onPlaceSelected: (place) => selectedPlace = place,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Columbus');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Columbus, OH, USA'), findsOneWidget);

      await tester.tap(find.text('Columbus, OH, USA'));
      await tester.pumpAndSettle();

      expect(selectedPlace, isNotNull);
      expect(selectedPlace?.displayName, equals('Columbus, OH, USA'));
      expect(controller.text, equals('Columbus, OH, USA'));
    });

    testWidgets('directly parses comma-separated coordinates', (tester) async {
      Place? selectedPlace;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceSearchInput(
              routingRepository: mockRepository,
              controller: controller,
              hintText: 'Search location...',
              prefixIcon: Icons.search,
              iconColor: Colors.blue,
              onPlaceSelected: (place) => selectedPlace = place,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '41.4993, -81.6944');
      await tester.pump();

      expect(selectedPlace, isNotNull);
      expect(selectedPlace?.coordinate.lat, equals(41.4993));
      expect(selectedPlace?.coordinate.lng, equals(-81.6944));
    });
  });
}
