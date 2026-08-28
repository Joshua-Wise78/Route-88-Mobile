import 'package:dio/dio.dart';

abstract class Route88RemoteDataSource {
  Future<List<dynamic>> getRoutes();
  Future<void> createRoute(Map<String, dynamic> routeData);
}

class Route88RemoteDataSourceImpl implements Route88RemoteDataSource {
  final Dio _dio;

  Route88RemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<dynamic>> getRoutes() async {
    try {
      final response = await _dio.get('/api/routes');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Failed to load routes: ${e.message}');
    }
  }

  @override
  Future<void> createRoute(Map<String, dynamic> routeData) async {}
}
