import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/core/network/models/paginated_response.dart';
import 'package:route_88/features/route88/models/construction.dart';

class ConstructionRepository {
  ConstructionRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<List<Construction>> getConstruction({
    double? latitude,
    double? longitude,
    double? radiusMiles,
    List<List<double>>? waypoints,
  }) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/construction',
        queryParameters: {
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          if (radiusMiles != null) 'radiusMiles': radiusMiles,
          if (waypoints != null) 'waypoints': waypoints,
        },
      );

      final data = response.data ?? <String, dynamic>{};
      final paginatedResponse = PaginatedResponse<Construction>.fromJson(
        data,
        Construction.fromJson,
      );

      return paginatedResponse.results;
    } on DioException catch (e) {
      throw Exception('Failed to fetch construction: ${e.message}');
    }
  }
}
