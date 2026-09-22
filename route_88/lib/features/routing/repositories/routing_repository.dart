import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/place.dart';
import 'package:route_88/features/routing/models/route_result.dart';

class RoutingRepository {
  RoutingRepository({required this.apiClient});

  final ApiClient apiClient;

  /// Hits the self-hosted Photon Geocoder to search for an address.
  Future<List<Place>> searchPlaces(String query) async {
    try {
      // Assuming you set up a custom endpoint on your backend that proxies 
      // to Photon, or you hit Photon directly. Update path as necessary.
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/geocode/api',
        queryParameters: {'q': query, 'limit': 5},
      );

      if (response.data != null && response.data!['features'] != null) {
        final features = response.data!['features'] as List<dynamic>;
        return features
            .map((e) => Place.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Hits the self-hosted OSRM backend to calculate a route.
  Future<RouteResult> getRoute(Coordinate start, Coordinate end) async {
    try {
      // Update the path to match your OSRM routing endpoint
      final startStr = start.toUrlValue();
      final endStr = end.toUrlValue();
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/route/v1/driving/$startStr;$endStr',
        queryParameters: {'overview': 'full', 'geometries': 'polyline6'},
      );

      if (response.data != null) {
        return RouteResult.fromJson(response.data!);
      }
      throw Exception('Empty response from OSRM');
    } catch (e) {
      rethrow;
    }
  }
}
