import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

sealed class RoutingEvent extends Equatable {
  const RoutingEvent();

  @override
  List<Object?> get props => [];
}

sealed class AutoCompleteAddressEvent extends RoutingEvent {
  const AutoCompleteAddressEvent();
}

class AutocompleteAddressRequested extends AutoCompleteAddressEvent {
  const AutocompleteAddressRequested({
    this.address,
  });

  final String? address;

  @override
  List<Object?> get props => [address];
}

sealed class CalculatedRouteEvent extends RoutingEvent {
  const CalculatedRouteEvent();
}

class CalculatedRouteRequested extends CalculatedRouteEvent {
  const CalculatedRouteRequested({
    this.startLat,
    this.startLong,
    this.endLat,
    this.endLong,
    this.start,
    this.end,
  });

  final double? startLat;
  final double? startLong;
  final double? endLat;
  final double? endLong;
  final Coordinate? start;
  final Coordinate? end;

  @override
  List<Object?> get props => [startLat, startLong, endLat, endLong, start, end];
}

sealed class ClearRouteEvent extends RoutingEvent {
  const ClearRouteEvent();
}

class ClearRouteRequested extends ClearRouteEvent {
  const ClearRouteRequested();
}

class ClearAutocompleteRequested extends RoutingEvent {
  const ClearAutocompleteRequested();
}

sealed class CommuteCheckEvent extends RoutingEvent {
  const CommuteCheckEvent();
}

class CommuteCheckRequested extends CommuteCheckEvent {
  const CommuteCheckRequested({
    this.start,
    this.end,
    this.polyline,
    this.bufferMiles = 0.31, // ~500 meters default
  });

  final Coordinate? start;
  final Coordinate? end;
  final List<Coordinate>? polyline;
  final double bufferMiles;

  @override
  List<Object?> get props => [start, end, polyline, bufferMiles];
}

class ClearCommuteRequested extends CommuteCheckEvent {
  const ClearCommuteRequested();
}
