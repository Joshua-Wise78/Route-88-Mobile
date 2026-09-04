import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/core/network/models/paginated_response.dart';
import 'package:route_88/features/route88/models/incident.dart';

class IncidentRepository {
  IncidentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Incident>> getIncidents({
    required double latitude,
    required double longitude,
    required double radiusMiles,
  }) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/incidents',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radiusMiles': radiusMiles,
        },
      );

      final data = response.data ?? <String, dynamic>{};
      final paginatedResponse = PaginatedResponse<Incident>.fromJson(
        data,
        Incident.fromJson,
      );

      return paginatedResponse.results;
    } on DioException catch (e) {
      throw Exception('Failed to fetch incidents: ${e.message}');
    }
  }
}
