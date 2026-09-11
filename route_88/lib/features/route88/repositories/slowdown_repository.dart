import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/core/network/models/paginated_response.dart';
import 'package:route_88/features/route88/models/slowdowns.dart';

class SlowdownRepository {
  SlowdownRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Slowdown>> getSlowdowns({
    double? latitude,
    double? longitude,
    double? radiusMiles,
    List<List<double>>? waypoints,
  }) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/slowdowns',
        queryParameters: {
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          if (radiusMiles != null) 'radiusMiles': radiusMiles,
          // Note: If waypoints gets complex, you might need to send them via POST,
          // but we'll include them here for now just in case your backend supports it via query.
          if (waypoints != null) 'waypoints': waypoints,
        },
      );

      final data = response.data ?? <String, dynamic>{};
      final paginatedResponse = PaginatedResponse<Slowdown>.fromJson(
        data,
        Slowdown.fromJson,
      );

      return paginatedResponse.results;
    } on DioException catch (e) {
      throw Exception('Failed to fetch slowdowns: ${e.message}');
    }
  }
}
