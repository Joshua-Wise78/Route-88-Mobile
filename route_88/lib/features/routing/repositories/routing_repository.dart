import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/routing/models/commute_check_result.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/place.dart';
import 'package:route_88/features/routing/models/route_result.dart';

class RoutingRepository {
  RoutingRepository({required this.apiClient});

  final ApiClient apiClient;

  /// Hits the self-hosted Nominatim Geocoder via the backend /autocomplete
  Future<List<Place>> searchPlaces(String query) async {
    try {
      Response<Map<String, dynamic>> response;
      try {
        response = await apiClient.dio.get<Map<String, dynamic>>(
          '/route/autocomplete',
          queryParameters: {'query': query},
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          final fallbackBase = apiClient.dio.options.baseUrl
              .replaceAll('/api/mobile', '/api/route');
          final fallbackUrl = fallbackBase.isNotEmpty
              ? '$fallbackBase/autocomplete'
              : 'https://wise-server.tail904182.ts.net:8443/api/route/autocomplete';
          response = await apiClient.dio.get<Map<String, dynamic>>(
            fallbackUrl,
            queryParameters: {'query': query},
          );
        } else {
          rethrow;
        }
      }

      final data = response.data;
      if (data != null && data['success'] == true && data['results'] != null) {
        final results = data['results'] as List<dynamic>;
        return results
            .map((e) => Place.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      final errorMsg = e.response?.data is Map<String, dynamic>
          ? (e.response?.data as Map<String, dynamic>)['error'] as String?
          : null;
      throw Exception(errorMsg ?? 'Failed to search places: ${e.message}');
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
    } on DioException catch (e) {
      final errorMsg = e.response?.data is Map<String, dynamic>
          ? (e.response?.data as Map<String, dynamic>)['error'] as String?
          : null;
      throw Exception(errorMsg ?? 'Failed to calculate route: ${e.message}');
    }
  }

  /// Hits the backend to check corridor hazards (incidents, slowdowns,
  /// construction) along a commute route within a buffer distance
  /// (default 0.31 miles / 500 meters).
  ///
  /// Supports either origin/destination coordinates or a custom
  /// polyline path.
  Future<CommuteCheckResult> checkCommuteRoute({
    Coordinate? start,
    Coordinate? end,
    List<Coordinate>? polyline,
    double bufferMiles = 0.31,
  }) async {
    try {
      final Response<Map<String, dynamic>> response;

      if (polyline != null && polyline.length >= 2) {
        response = await apiClient.dio.post<Map<String, dynamic>>(
          '/route/check',
          data: {
            'coordinates': polyline.map((c) => [c.lng, c.lat]).toList(),
            'bufferMiles': bufferMiles,
            if (start != null) 'startLat': start.lat,
            if (start != null) 'startLon': start.lng,
            if (end != null) 'endLat': end.lat,
            if (end != null) 'endLon': end.lng,
          },
        );
      } else if (start != null && end != null) {
        response = await apiClient.dio.get<Map<String, dynamic>>(
          '/route/check',
          queryParameters: {
            'startLat': start.lat,
            'startLon': start.lng,
            'endLat': end.lat,
            'endLon': end.lng,
            'bufferMiles': bufferMiles,
          },
        );
      } else {
        throw ArgumentError(
          'Either provide start and end coordinates or a polyline.',
        );
      }

      final data = response.data;
      if (data != null && data['success'] == true) {
        return CommuteCheckResult.fromJson(data);
      }
      throw Exception(
        data?['error'] as String? ?? 'Failed to check commute route clearance',
      );
    } on DioException catch (e) {
      final errorMsg = e.response?.data is Map<String, dynamic>
          ? (e.response?.data as Map<String, dynamic>)['error'] as String?
          : null;
      throw Exception(
        errorMsg ?? 'Failed to check commute route: ${e.message}',
      );
    }
  }
}
