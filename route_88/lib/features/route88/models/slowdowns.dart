import 'package:route_88/features/route88/models/base.dart' show Base, Link;

class Slowdown extends Base {
  Slowdown({
    required super.id,
    required super.latitude,
    required super.longitude,
    super.location,
    super.description,
    super.category,
    super.direction,
    super.routeName,
    this.normalMPH,
    this.currentMPH,
  });

  factory Slowdown.fromJson(Map<String, dynamic> json) {
    return Slowdown(
      id: json['id'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      direction: json['direction'] as String?,
      routeName: json['routeName'] as String?,
      normalMPH: (json['normalMPH'] as num?)?.toInt(),
      currentMPH: (json['currentMPH'] as num?)?.toInt(),
    );
  }

  final int? normalMPH;
  final int? currentMPH;
}
