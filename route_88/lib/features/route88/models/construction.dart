import 'package:route_88/features/route88/models/base.dart' show Base, Link;

class Construction extends Base {
  Construction({
    required super.id,
    required super.latitude,
    required super.longitude,
    required this.status,
    required this.district,
    required this.startDate,
    required this.endDate,
    this.workZone,
    super.location,
    super.description,
    super.category,
    super.direction,
    super.routeName,
    super.link,
  });

  factory Construction.fromJson(Map<String, dynamic> json) {
    return Construction(
      id: json['id'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      district: json['district'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      workZone: json['workZone'] != null
          ? ConstructionWorkZone.fromJson(
              json['workZone'] as Map<String, dynamic>,
            )
          : null,
      location: json['location'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      direction: json['direction'] as String?,
      routeName: json['routeName'] as String?,
      link: json['link'] != null
          ? Link.fromJson(json['link'] as Map<String, dynamic>)
          : null,
    );
  }

  final String status;
  final String district;
  final String startDate;
  final String endDate;
  final ConstructionWorkZone? workZone;
}

class ConstructionWorkZone {
  ConstructionWorkZone({
    this.description,
    this.startLocation,
    this.endLocation,
    this.polyline,
  });

  factory ConstructionWorkZone.fromJson(Map<String, dynamic> json) {
    return ConstructionWorkZone(
      description: json['description'] as String?,
      startLocation: (json['startLocation'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      endLocation: (json['endLocation'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      polyline: (json['polyline'] as List<dynamic>?)
          ?.map(
            (e) => (e as List<dynamic>)
                .map((e2) => (e2 as num).toDouble())
                .toList(),
          )
          .toList(),
    );
  }

  final String? description;
  final List<double>? startLocation;
  final List<double>? endLocation;
  final List<List<double>>? polyline;
}

class ConstructionDetour {
  ConstructionDetour({
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.detourRoute,
  });

  factory ConstructionDetour.fromJson(Map<String, dynamic> json) {
    return ConstructionDetour(
      name: json['name'] as String?,
      description: json['description'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      detourRoute: json['detourRoute'] != null
          ? ConstructionDetourRoute.fromJson(
              json['detourRoute'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final String? name;
  final String? description;
  final String? startDate;
  final String? endDate;
  final ConstructionDetourRoute? detourRoute;
}

class ConstructionDetourRoute {
  ConstructionDetourRoute({
    this.roadName,
    this.startLocation,
    this.endLocation,
    this.polyline,
  });

  factory ConstructionDetourRoute.fromJson(Map<String, dynamic> json) {
    return ConstructionDetourRoute(
      roadName: json['roadName'] as String?,
      startLocation: (json['startLocation'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      endLocation: (json['endLocation'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      polyline: (json['polyline'] as List<dynamic>?)
          ?.map(
            (e) => (e as List<dynamic>)
                .map((e2) => (e2 as num).toDouble())
                .toList(),
          )
          .toList(),
    );
  }

  final String? roadName;
  final List<double>? startLocation;
  final List<double>? endLocation;
  final List<List<double>>? polyline;
}
