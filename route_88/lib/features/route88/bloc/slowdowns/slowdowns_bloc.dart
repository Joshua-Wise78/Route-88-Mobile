import 'package:bloc/bloc.dart';
import 'package:route_88/features/route88/bloc/slowdowns/slowdowns_event.dart';
import 'package:route_88/features/route88/bloc/slowdowns/slowdowns_state.dart';
import 'package:route_88/features/route88/repositories/slowdown_repository.dart';

class SlowdownsBloc extends Bloc<SlowdownsEvent, SlowdownsState> {
  SlowdownsBloc({
    required SlowdownRepository repository,
  })  : _repository = repository,
        super(const SlowdownsInitial()) {
    on<SlowdownsRequested>(_onSlowdownsRequested);
  }

  final SlowdownRepository _repository;

  Future<void> _onSlowdownsRequested(
    SlowdownsRequested event,
    Emitter<SlowdownsState> emit,
  ) async {
    emit(const SlowdownsLoading());

    try {
      final slowdowns = await _repository.getSlowdowns(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusMiles: event.radiusMiles,
        waypoints: event.waypoints,
      );

      emit(SlowdownsLoaded(slowdowns));
    } catch (e) {
      emit(SlowdownsError(e.toString()));
    }
  }
}
