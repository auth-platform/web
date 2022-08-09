import 'package:auth_platform/api/api_data_decoder.dart';
import 'package:auth_platform/api/api_response.dart';
import 'package:auth_platform/config.dart';
import 'package:dio/dio.dart';

class APIService {
  static final shared = APIService();

  APIService() {
    _dio = Dio(BaseOptions()..baseUrl = Environment.authBaseUrl);
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.next(options);
    }, onResponse: (response, handler) {
      response.data = APIResponse.fromMap(response.data, response.statusCode, (data) => data);
      handler.next(response);
    }));
    _dio.interceptors.add(LogInterceptor());
  }

  late final Dio _dio;

  Future<APIResponse<T>> request<T>(String path, {String method = 'GET', dynamic data}) {
    return _dio.request(path, options: Options(method: method), data: data).then((res) {
      final apiRes = res.data as APIResponse;
      return apiRes.map((data) => APIDataDecoder.shared.decode<T>(data));
    });
  }

  void updateBearerToken(String? token) {
    _dio.options.headers['Authorization'] = token != null ? 'Bearer $token' : null;
  }
}
