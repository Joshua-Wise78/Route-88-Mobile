import 'package:bloc/bloc.dart';
import 'package:route_88/features/route88/bloc/construction/construction_event.dart';
import 'package:route_88/features/route88/bloc/construction/construction_state.dart';
import 'package:route_88/features/route88/repositories/construction_repository.dart';

class ConstructionBloc extends Bloc<ConstructionEvent, ConstructionState> {
  ConstructionBloc({
    required this.repository,
  }) : super(const ConstructionInitial()) {
    on<ConstructionRequested>(_onConstructionRequested);
  }

  final ConstructionRepository repository;

  Future<void> _onConstructionRequested(
    ConstructionRequested event,
    Emitter<ConstructionState> emit,
  ) async {
    emit(const ConstructionLoading());

    try {
      final construction = await repository.getConstruction(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusMiles: event.radiusMiles,
        waypoints: event.waypoints,
      );

      emit(ConstructionLoaded(construction));
    } on Exception catch (e) {
      emit(ConstructionError(e.toString()));
    }
  }
}
