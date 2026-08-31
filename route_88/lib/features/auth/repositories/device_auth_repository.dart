import 'package:dio/dio.dart';
import 'package:route_88/core/network/api_client.dart';

class DeviceAuthRepository {
  DeviceAuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<bool> registerDevice(String deviceId) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/register',
        data: {'deviceId': deviceId},
      );
      return response.data?['success'] == true;
    } on DioException catch (e) {
      throw Exception('Failed to register device: ${e.message}');
    }
  }
}
