import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/features/home/widgets/commute_picker_sheet.dart';
import 'package:route_88/features/routing/bloc/routing_bloc.dart';
import 'package:route_88/features/routing/bloc/routing_event.dart';
import 'package:route_88/features/routing/bloc/routing_state.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';

class MockRoutingBloc extends Mock implements RoutingBloc {}

class MockRoutingRepository extends Mock implements RoutingRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const ClearCommuteRequested());
  });

  group('CommutePickerSheet', () {
    late MockRoutingBloc mockBloc;
    late MockRoutingRepository mockRepository;

    setUp(() {
      mockBloc = MockRoutingBloc();
      mockRepository = MockRoutingRepository();

      when(() => mockBloc.state).thenReturn(const RoutingInitial());
      when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
    });

    Widget buildSheet({
      double? currentLatitude = 39.9612,
      double? currentLongitude = -83.0019,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: RepositoryProvider<RoutingRepository>.value(
            value: mockRepository,
            child: BlocProvider<RoutingBloc>.value(
              value: mockBloc,
              child: CommutePickerSheet(
                currentLatitude: currentLatitude,
                currentLongitude: currentLongitude,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders title and tabs', (tester) async {
      await tester.pumpWidget(buildSheet());

      expect(find.text('Check Route Hazards'), findsNWidgets(2));
      expect(find.text('Custom Route'), findsOneWidget);
      expect(find.text('Corridors'), findsOneWidget);
      expect(find.text('Use Current Location'), findsOneWidget);
    });

    testWidgets('tapping Use Current Location populates start location',
        (tester) async {
      await tester.pumpWidget(buildSheet());

      await tester.tap(find.text('Use Current Location'));
      await tester.pump();

      expect(find.text('My Current Location'), findsOneWidget);
    });

    testWidgets(
      'tapping an Ohio Corridor preset dispatches CommuteCheckRequested',
      (tester) async {
      await tester.pumpWidget(buildSheet());

      // Switch to Presets tab
      await tester.tap(find.text('Corridors'));
      await tester.pumpAndSettle();

      expect(find.text('Columbus ➔ Cincinnati (I-71 S)'), findsOneWidget);

      await tester.tap(find.text('Columbus ➔ Cincinnati (I-71 S)'));
      await tester.pump();

      verify(
        () => mockBloc.add(
          any(that: isA<CommuteCheckRequested>()),
        ),
      ).called(1);
    });
  });
}
