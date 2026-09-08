sealed class IncidentsEvent {
  const IncidentsEvent();
}

class IncidentsRequested extends IncidentsEvent {
  const IncidentsRequested({
    required this.latitude,
    required this.longitude,
    required this.radiusMiles,
  });

  final double latitude;
  final double longitude;
  final double radiusMiles;
}
