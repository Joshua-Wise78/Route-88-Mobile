import 'package:equatable/equatable.dart';

class Coordinate extends Equatable {
  const Coordinate({required this.lat, required this.lng});

  factory Coordinate.formJson(Map<String, dynamic> json) {
    return Coordinate(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };

  String toUrlValue() => '$lng,$lat';

  @override
  List<Object?> get props => [lat, lng];
}
