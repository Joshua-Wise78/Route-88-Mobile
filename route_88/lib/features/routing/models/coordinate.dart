import 'package:equatable/equatable.dart';

class Coordinate extends Equatable {
  const Coordinate({
    required this.lat,
    required this.lng,
  });

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    final lon = json['lng'] ?? json['lon'];
    return Coordinate(
      lat: (json['lat'] as num).toDouble(),
      lng: (lon as num).toDouble(),
    );
  }

  @Deprecated('Use fromJson instead')
  factory Coordinate.formJson(Map<String, dynamic> json) =>
      Coordinate.fromJson(json);

  final double lat;
  final double lng;

  Coordinate copyWith({
    double? lat,
    double? lng,
  }) {
    return Coordinate(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };

  String toUrlValue() => '$lng,$lat';

  @override
  List<Object?> get props => [lat, lng];
}
