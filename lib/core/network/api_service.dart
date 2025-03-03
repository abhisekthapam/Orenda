import 'package:dio/dio.dart';
import 'package:orenda/app/constants/api_endpoints.dart';
import 'package:orenda/core/network/dio_error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = const Duration(seconds: 30) 
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true))
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await _dio.get("${ApiEndpoints.baseUrl}${ApiEndpoints.getProducts}");
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception("Unexpected response format: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error fetching products: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error fetching products: $e");
    }
  }
}
