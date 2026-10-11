import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/place.dart';
import 'package:route_88/features/routing/models/route_result.dart';

sealed class RoutingState extends Equatable {
  const RoutingState();

  RouteResult? get route => null;
  List<Place> get places => const [];

  @override
  List<Object?> get props => [];
}

class RoutingInitial extends RoutingState {
  const RoutingInitial();
}

sealed class AutoCompleteState extends RoutingState {
  const AutoCompleteState();
}

class AutoCompleteInitial extends RoutingInitial {
  const AutoCompleteInitial();
}

class AutoCompleteLoading extends AutoCompleteState {
  const AutoCompleteLoading({
    this.route,
  });

  @override
  final RouteResult? route;

  @override
  List<Object?> get props => [route];
}

class AutoCompleteLoaded extends AutoCompleteState {
  const AutoCompleteLoaded({
    required this.places,
    this.route,
  });

  @override
  final List<Place> places;

  @override
  final RouteResult? route;

  Place? get autocomplete => places.isNotEmpty ? places.first : null;

  @override
  List<Object?> get props => [places, route];
}

sealed class RouteCalculationState extends RoutingState {
  const RouteCalculationState();
}

class RouteCalculationLoading extends RouteCalculationState {
  const RouteCalculationLoading({
    this.places = const [],
  });

  @override
  final List<Place> places;

  @override
  List<Object?> get props => [places];
}

class RouteCalculated extends RouteCalculationState {
  const RouteCalculated({
    required this.route,
    this.places = const [],
  });

  @override
  final RouteResult route;

  @override
  final List<Place> places;

  @override
  List<Object?> get props => [route, places];
}

class RoutingError extends RoutingState {
  const RoutingError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AutoCompleteError extends RoutingError {
  const AutoCompleteError(super.message);
}

class RouteCalculationError extends RoutingError {
  const RouteCalculationError(super.message);
}
