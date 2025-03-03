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
      final response =
          await _dio.get("${ApiEndpoints.baseUrl}${ApiEndpoints.getProducts}");
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

  Future<void> placeOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await _dio.post(
        "${ApiEndpoints.baseUrl}orders",
        data: orderData,
      );

      if (response.statusCode == 201) {
      } else {
        throw Exception("Failed to place order: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error placing order: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await _dio.get("${ApiEndpoints.baseUrl}orders");

      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception("Unexpected response format: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Dio error fetching orders: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error fetching orders: $e");
    }
  }

  Future<void> updateOrder(
      String orderId, List<Map<String, dynamic>> items, String status) async {
    try {
      final response = await _dio.put(
        "${ApiEndpoints.baseUrl}orders/$orderId",
        data: {"items": items, "status": status},
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update order: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error updating order: $e");
    }
  }

  Future<void> patchOrder(
      String orderId, Map<String, dynamic> updateData) async {
    try {
      final response = await _dio.patch(
        "${ApiEndpoints.baseUrl}orders/$orderId",
        data: updateData,
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update order: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error updating order: $e");
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      final response =
          await _dio.delete("${ApiEndpoints.baseUrl}orders/$orderId");

      if (response.statusCode != 200) {
        throw Exception("Failed to delete order: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error deleting order: $e");
    }
  }
}
