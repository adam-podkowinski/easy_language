import 'package:dio/dio.dart';
import 'package:easy_language/core/api/auth_interceptor.dart';
import 'package:hive/hive.dart';

abstract class ApiRepository {
  final Dio api;

  Dio call();

  ApiRepository(this.api);
}

class ApiRepositoryImpl implements ApiRepository {
  @override
  final Dio api;
  final Box apiBox;
  @override
  Dio call() => api;

  String? accessToken;

  ApiRepositoryImpl(this.api, this.apiBox) {
    api.interceptors.add(AuthInterceptor(api, apiBox));
  }
}
