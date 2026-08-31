import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';
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
      final response = await _apiClient.dio.get<List<dynamic>>(
        '/incidents',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radiusMiles': radiusMiles,
        },
      );

      final data = response.data ?? [];
      return data
          .map((json) => Incident.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch incidents: ${e.message}');
    }
  }
}
