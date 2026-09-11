sealed class SlowdownsEvent {
  const SlowdownsEvent();
}

class SlowdownsRequested extends SlowdownsEvent {
  const SlowdownsRequested({
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
