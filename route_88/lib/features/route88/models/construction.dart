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
    super.direction,
    super.routeName,
  });

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
      startLocation:
          (json['startLocation'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
    );
  }

  final String? roadName;
  final List<int>? startLocation;
  final List<int>? endLocation;
  final List<List<double>>? polyline;
}
