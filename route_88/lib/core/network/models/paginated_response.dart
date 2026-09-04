class PaginatedResponse<T> {
  PaginatedResponse({
    required this.totalPageCount,
    required this.totalResultCount,
    required this.results,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      totalPageCount: json['totalPageCount'] as int? ?? 0,
      totalResultCount: json['totalResultCount'] as int? ?? 0,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final int totalPageCount;
  final int totalResultCount;
  final List<T> results;
}
