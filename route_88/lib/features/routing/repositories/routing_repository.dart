import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/place.dart';
import 'package:route_88/features/routing/models/route_result.dart';

class RoutingRepository {
  RoutingRepository({required this.apiClient});

  final ApiClient apiClient;

  /// Hits the self-hosted Nominatim Geocoder via the backend /autocomplete
  Future<List<Place>> searchPlaces(String query) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/route/autocomplete',
        queryParameters: {'query': query},
      );

      final data = response.data;
      if (data != null && data['success'] == true && data['results'] != null) {
        final results = data['results'] as List<dynamic>;
        return results
            .map((e) => Place.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Hits the backend to calculate a route between two coordinates.
  Future<RouteResult> getRoute(Coordinate start, Coordinate end) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/route/calculate',
        queryParameters: {
          'startLat': start.lat,
          'startLon': start.lng,
          'endLat': end.lat,
          'endLon': end.lng,
        },
      );

      final data = response.data;
      if (data != null && data['success'] == true && data['route'] != null) {
        return RouteResult.fromJson(data['route'] as Map<String, dynamic>);
      }
      throw Exception(
        'Empty or failed response from backend route calculation',
      );
    } catch (e) {
      rethrow;
    }
  }
}
