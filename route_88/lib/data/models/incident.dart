class IncidentResponse {
  IncidentResponse({
    required this.totalPageCount,
    required this.totalResultCount,
    required this.results,
  });

  factory IncidentResponse.fromJson(Map<String, dynamic> json) {
    return IncidentResponse(
      totalPageCount: json['totalPageCount'] as int? ?? 0,
      totalResultCount: json['totalResultCount'] as int? ?? 0,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => Incident.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final int totalPageCount;
  final int totalResultCount;
  final List<Incident> results;
}

class Incident {
  Incident({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.description,
    required this.category,
    required this.roadStatus,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      roadStatus: json['roadStatus'] as String? ?? '',
    );
  }

  final String id;
  final double latitude;
  final double longitude;
  final String location;
  final String description;
  final String category;
  final String roadStatus;
}
