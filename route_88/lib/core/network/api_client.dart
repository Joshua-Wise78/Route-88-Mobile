import 'package:dio/dio.dart';
import 'package:route_88/core/settings/app_settings.dart';

const internalApiKey = String.fromEnvironment('INTERNAL_API_KEY');

class ApiClient {
  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: AppSettings.instance.mobileApiUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
    AppSettings.instance.addListener(_syncServerUrl);

    dio.interceptors.addAll([
      _AuthInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final Dio dio;

  void _syncServerUrl() {
    dio.options.baseUrl = AppSettings.instance.mobileApiUrl;
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $internalApiKey';
    super.onRequest(options, handler);
  }
}
