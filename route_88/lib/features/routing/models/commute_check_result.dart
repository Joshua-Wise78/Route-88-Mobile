import 'package:equatable/equatable.dart';
import 'package:route_88/features/routing/models/commute_route.dart';
import 'package:route_88/features/routing/models/route_check_summary.dart';
import 'package:route_88/features/routing/models/route_hazard.dart';

/// Top-level response from the backend commute corridor check.
class CommuteCheckResult extends Equatable {
  /// 1. Main Constructor First
  const CommuteCheckResult({
    required this.success,
    required this.isClear,
    required this.status,
    required this.summary,
    required this.route,
    required this.corridorBufferMiles,
    required this.hazards,
  });

  /// 2. Factory Constructors Next
  factory CommuteCheckResult.fromJson(Map<String, dynamic> json) {
    final rawHazards = json['hazards'] as List<dynamic>? ?? [];
    return CommuteCheckResult(
      success: json['success'] as bool? ?? true,
      isClear: json['isClear'] as bool? ?? false,
      status: json['status'] as String? ?? 'clear',
      summary: RouteCheckSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      route: CommuteRoute.fromJson(
        json['route'] as Map<String, dynamic>? ?? {},
      ),
      corridorBufferMiles:
          (json['corridorBufferMiles'] as num?)?.toDouble() ?? 0.31,
      hazards: rawHazards
          .map((h) => RouteHazard.fromJson(h as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 3. Final Fields Below Constructors
  final bool success;
  final bool isClear;
  /// Status: 'clear', 'minor_delays', 'moderate_hazards', 'severe_hazards'
  final String status;
  final RouteCheckSummary summary;
  final CommuteRoute route;
  final double corridorBufferMiles;
  final List<RouteHazard> hazards;

  /// Helper getters for UI categorization
  List<RouteHazard> get incidents =>
      hazards.where((h) => h.isIncident).toList();

  List<RouteHazard> get slowdowns =>
      hazards.where((h) => h.isSlowdown).toList();

  List<RouteHazard> get construction =>
      hazards.where((h) => h.isConstruction).toList();

  bool get hasHazards => hazards.isNotEmpty;

  /// 4. Methods / Overrides
  Map<String, dynamic> toJson() => {
        'success': success,
        'isClear': isClear,
        'status': status,
        'summary': summary.toJson(),
        'route': route.toJson(),
        'corridorBufferMiles': corridorBufferMiles,
        'hazards': hazards.map((h) => h.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        success,
        isClear,
        status,
        summary,
        route,
        corridorBufferMiles,
        hazards,
      ];
}
