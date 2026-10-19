import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/core/network/models/paginated_response.dart';
import 'package:route_88/features/route88/models/incident.dart';

class IncidentRepository {
  IncidentRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<List<Incident>> getIncidents({
    double? latitude,
    double? longitude,
    double? radiusMiles,
  }) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/incidents',
        queryParameters: {
          'latitude': ?latitude,
          'longitude': ?longitude,
          'radiusMiles': ?radiusMiles,
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
