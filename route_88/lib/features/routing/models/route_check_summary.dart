import 'package:equatable/equatable.dart';

/// Aggregated breakdown of hazards detected along a commute route.
class RouteCheckSummary extends Equatable {
  /// 1. Main Constructor First
  const RouteCheckSummary({
    required this.totalHazards,
    required this.incidentsCount,
    required this.slowdownsCount,
    required this.constructionCount,
    required this.message,
  });

  /// 2. Factory Constructors Next
  factory RouteCheckSummary.fromJson(Map<String, dynamic> json) {
    return RouteCheckSummary(
      totalHazards: (json['totalHazards'] as num?)?.toInt() ?? 0,
      incidentsCount: (json['incidentsCount'] as num?)?.toInt() ?? 0,
      slowdownsCount: (json['slowdownsCount'] as num?)?.toInt() ?? 0,
      constructionCount: (json['constructionCount'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
    );
  }

  /// 3. Final Fields Below Constructors
  final int totalHazards;
  final int incidentsCount;
  final int slowdownsCount;
  final int constructionCount;
  final String message;

  /// 4. Methods / Overrides
  Map<String, dynamic> toJson() => {
        'totalHazards': totalHazards,
        'incidentsCount': incidentsCount,
        'slowdownsCount': slowdownsCount,
        'constructionCount': constructionCount,
        'message': message,
      };

  @override
  List<Object?> get props => [
        totalHazards,
        incidentsCount,
        slowdownsCount,
        constructionCount,
        message,
      ];
}
