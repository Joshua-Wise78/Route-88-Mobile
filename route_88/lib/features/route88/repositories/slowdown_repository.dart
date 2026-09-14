import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/core/network/models/paginated_response.dart';
import 'package:route_88/features/route88/models/slowdowns.dart';

class SlowdownRepository {
  SlowdownRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<List<Slowdown>> getSlowdowns({
    double? latitude,
    double? longitude,
    double? radiusMiles,
    List<List<double>>? waypoints,
  }) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/slowdowns',
        queryParameters: {
          'latitude': ?latitude,
          'longitude': ?longitude,
          'radiusMiles': ?radiusMiles,
          'waypoints': ?waypoints,
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
