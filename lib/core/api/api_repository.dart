import 'package:dio/dio.dart';
import 'package:easy_language/core/api/auth_interceptor.dart';
import 'package:hive/hive.dart';

class ApiRepository {
  final Dio api;
  final Box apiBox;

  Dio call() => api;

  ApiRepository(this.api, this.apiBox) {
    api.interceptors.add(AuthInterceptor(api, apiBox));
    api.interceptors.add(LogInterceptor());
  }
}
