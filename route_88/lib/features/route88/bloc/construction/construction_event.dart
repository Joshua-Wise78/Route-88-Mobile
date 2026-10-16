sealed class ConstructionEvent {
  const ConstructionEvent();
}

class ConstructionRequested extends ConstructionEvent {
  const ConstructionRequested({
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
