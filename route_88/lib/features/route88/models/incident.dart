import 'package:route_88/features/route88/models/base.dart' show Base, Link;

class Incident extends Base {
  Incident({
    required super.id,
    required super.latitude,
    required super.longitude,
    super.location,
    super.description,
    super.category,
    super.direction,
    super.routeName,
    this.roadStatus,
    super.link,
    this.roadClosureDetail,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      direction: json['direction'] as String?,
      routeName: json['routeName'] as String?,
      link: json['link'] != null
          ? Link.fromJson(json['link'] as Map<String, dynamic>)
          : null,
      roadStatus: json['roadStatus'] as String?,
      roadClosureDetail: json['roadClosureDetail'] != null
          ? RoadClosureDetail.fromJson(
              json['roadClosureDetail'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final String? roadStatus;
  final RoadClosureDetail? roadClosureDetail;
}

class RoadClosureDetail {
  RoadClosureDetail({
    required this.closureStartLocation,
    required this.closureEndLocation,
    required this.polyline,
  });

  factory RoadClosureDetail.fromJson(Map<String, dynamic> json) {
    return RoadClosureDetail(
      closureStartLocation:
          (json['closureStartLocation'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      closureEndLocation:
          (json['closureEndLocation'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      polyline:
          (json['polyline'] as List<dynamic>?)
              ?.map(
                (e) => (e as List<dynamic>)
                    .map((e2) => (e2 as num).toDouble())
                    .toList(),
              )
              .toList() ??
          [],
    );
  }

  final List<double> closureStartLocation;
  final List<double> closureEndLocation;
  final List<List<double>> polyline;
}
