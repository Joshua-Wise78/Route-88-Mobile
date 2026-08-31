class ApiStatus {
  ApiStatus({
    required this.status,
    required this.forTarget,
  });

  factory ApiStatus.fromJson(Map<String, dynamic> json) {
    return ApiStatus(
      status: json['status'] as String,
      forTarget: json['for'] as String,
    );
  }

  final String status;
  final String forTarget;
}
