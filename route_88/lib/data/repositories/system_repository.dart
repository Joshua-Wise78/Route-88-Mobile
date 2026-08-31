import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/data/models/api_status.dart';

class SystemRepository {
  SystemRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ApiStatus> getStatus() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/status',
      );
      return ApiStatus.fromJson(response.data!);
    } on DioException catch (e) {
      throw Exception('Failed to fetch status: ${e.message}');
    }
  }
}
