import 'package:bloc/bloc.dart';
import 'package:route_88/features/routing/bloc/routing_event.dart';
import 'package:route_88/features/routing/bloc/routing_state.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';

class RoutingBloc extends Bloc<RoutingEvent, RoutingState> {
  RoutingBloc({
    required this.routingRepository,
  }) : super(const RoutingInitial()) {
    on<AutocompleteAddressRequested>(_onAutocompleteAddressRequested);
    on<CalculatedRouteRequested>(_onCalculatedRouteRequested);
    on<ClearRouteRequested>(_onClearRouteRequested);
    on<ClearAutocompleteRequested>(_onClearAutocompleteRequested);
    on<CommuteCheckRequested>(_onCommuteCheckRequested);
    on<ClearCommuteRequested>(_onClearCommuteRequested);
  }

  final RoutingRepository routingRepository;

  Future<void> _onAutocompleteAddressRequested(
    AutocompleteAddressRequested event,
    Emitter<RoutingState> emit,
  ) async {
    final address = event.address?.trim();
    if (address == null || address.length < 2) {
      emit(AutoCompleteLoaded(places: const [], route: state.route));
      return;
    }

    emit(AutoCompleteLoading(route: state.route));

    try {
      final places = await routingRepository.searchPlaces(address);
      emit(AutoCompleteLoaded(places: places, route: state.route));
    } on Exception catch (e) {
      emit(AutoCompleteError(e.toString()));
    }
  }

  Future<void> _onCalculatedRouteRequested(
    CalculatedRouteRequested event,
    Emitter<RoutingState> emit,
  ) async {
    final start = event.start ??
        (event.startLat != null && event.startLong != null
            ? Coordinate(lat: event.startLat!, lng: event.startLong!)
            : null);
    final end = event.end ??
        (event.endLat != null && event.endLong != null
            ? Coordinate(lat: event.endLat!, lng: event.endLong!)
            : null);

    if (start == null || end == null) {
      emit(
        const RouteCalculationError(
          'Start and end coordinates are required to calculate a route.',
        ),
      );
      return;
    }

    emit(RouteCalculationLoading(places: state.places));

    try {
      final route = await routingRepository.getRoute(start, end);
      emit(RouteCalculated(route: route, places: state.places));
    } on Exception catch (e) {
      emit(RouteCalculationError(e.toString()));
    }
  }

  Future<void> _onCommuteCheckRequested(
    CommuteCheckRequested event,
    Emitter<RoutingState> emit,
  ) async {
    emit(
      CommuteCheckLoading(
        places: state.places,
        route: state.route,
        previousCommuteResult: state.commuteResult,
      ),
    );

    try {
      final result = await routingRepository.checkCommuteRoute(
        start: event.start,
        end: event.end,
        polyline: event.polyline,
        bufferMiles: event.bufferMiles,
      );
      emit(
        CommuteCheckLoaded(
          commuteResult: result,
          places: state.places,
          route: state.route,
        ),
      );
    } on Exception catch (e) {
      emit(CommuteCheckError(e.toString()));
    }
  }

  void _onClearRouteRequested(
    ClearRouteRequested event,
    Emitter<RoutingState> emit,
  ) {
    if (state.places.isNotEmpty) {
      emit(AutoCompleteLoaded(places: state.places));
    } else {
      emit(const RoutingInitial());
    }
  }

  void _onClearAutocompleteRequested(
    ClearAutocompleteRequested event,
    Emitter<RoutingState> emit,
  ) {
    if (state.route != null) {
      emit(RouteCalculated(route: state.route!));
    } else {
      emit(const RoutingInitial());
    }
  }

  void _onClearCommuteRequested(
    ClearCommuteRequested event,
    Emitter<RoutingState> emit,
  ) {
    if (state.places.isNotEmpty) {
      emit(AutoCompleteLoaded(places: state.places));
    } else if (state.route != null) {
      emit(RouteCalculated(route: state.route!));
    } else {
      emit(const RoutingInitial());
    }
  }
}
