import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:orenda/core/network/api_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  if (!locator.isRegistered<Dio>()) {
    locator.registerLazySingleton<Dio>(() {
      Dio dio = Dio();
      dio.options.baseUrl = "http://10.0.2.2:3000/api/";
      return dio;
    });
  }

  if (!locator.isRegistered<ApiService>()) {
    locator.registerLazySingleton<ApiService>(() => ApiService(locator<Dio>()));
  }
}
