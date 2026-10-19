import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/features/route88/bloc/routing/routing_bloc.dart';
import 'package:route_88/features/route88/bloc/routing/routing_event.dart';
import 'package:route_88/features/route88/bloc/routing/routing_state.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';

class MockRoutingRepository extends Mock implements RoutingRepository {}

void main() {
  group('Route88 Routing Bloc re-exports', () {
    test('RoutingBloc, RoutingEvent, and RoutingState re-exports work', () {
      final mockRepo = MockRoutingRepository();
      final bloc = RoutingBloc(routingRepository: mockRepo);

      expect(bloc.state, isA<RoutingState>());
      expect(const RoutingInitial(), isA<RoutingState>());
      expect(const ClearRouteRequested(), isA<RoutingEvent>());
    });
  });
}
