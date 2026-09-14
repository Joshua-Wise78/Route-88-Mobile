sealed class IncidentsEvent {
  const IncidentsEvent();
}

class IncidentsRequested extends IncidentsEvent {
  const IncidentsRequested({
    this.latitude,
    this.longitude,
    this.radiusMiles,
    this.waypoints,
  });

  final double? latitude;
  final double? longitude;
  final double? radiusMiles;
  final List<List<double>>? waypoints;
}
