import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_bloc.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_event.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_state.dart';
import 'package:route_88/features/route88/domain/usecases/get_incidents_usecase.dart';
import 'package:route_88/features/route88/models/incident.dart';

class MockGetIncidentsUseCase extends Mock implements GetIncidentsUseCase {}

void main() {
  group('IncidentsBloc', () {
    late MockGetIncidentsUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockGetIncidentsUseCase();
    });

    blocTest<IncidentsBloc, IncidentsState>(
      'emits [IncidentsLoading, IncidentsLoaded] when request succeeds',
      build: () {
        when(
          () => mockUseCase.call(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMiles: any(named: 'radiusMiles'),
          ),
        ).thenAnswer(
          (_) async => [Incident(id: '1', latitude: 35, longitude: -80)],
        );

        return IncidentsBloc(getIncidentsUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(
        const IncidentsRequested(latitude: 35, longitude: -80, radiusMiles: 10),
      ),
      expect: () => [
        isA<IncidentsLoading>(),
        isA<IncidentsLoaded>().having(
          (state) => state.incidents.length,
          'length',
          1,
        ),
      ],
    );

    blocTest<IncidentsBloc, IncidentsState>(
      'emits [IncidentsLoading, IncidentsError] when request fails',
      build: () {
        when(
          () => mockUseCase.call(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            radiusMiles: any(named: 'radiusMiles'),
          ),
        ).thenThrow(Exception('Failed to fetch'));

        return IncidentsBloc(getIncidentsUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(
        const IncidentsRequested(latitude: 35, longitude: -80, radiusMiles: 10),
      ),
      expect: () => [
        isA<IncidentsLoading>(),
        isA<IncidentsError>(),
      ],
    );
  });
}
