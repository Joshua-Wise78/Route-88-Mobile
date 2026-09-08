import 'package:bloc/bloc.dart';
import 'package:route_88/features/route88/bloc/incidents_event.dart';
import 'package:route_88/features/route88/bloc/incidents_state.dart';
import 'package:route_88/features/route88/domain/usecases/get_incidents_usecase.dart';

class IncidentsBloc extends Bloc<IncidentsEvent, IncidentsState> {
  IncidentsBloc({
    required GetIncidentsUseCase getIncidentsUseCase,
  })  : _getIncidentsUseCase = getIncidentsUseCase,
        super(const IncidentInitial()) {
    on<IncidentsRequested>(_onIncidentsRequested);
  }

  final GetIncidentsUseCase _getIncidentsUseCase;

  Future<void> _onIncidentsRequested(
    IncidentsRequested event,
    Emitter<IncidentsState> emit,
  ) async {
    emit(const IncidentsLoading());
    try {
      final incidents = await _getIncidentsUseCase(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusMiles: event.radiusMiles,
      );
      
      emit(IncidentsLoaded(incidents));
    } on Exception catch (e) {
      emit(IncidentsError(e.toString()));
    }
  }
}
