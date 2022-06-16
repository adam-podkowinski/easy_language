import 'package:dio/dio.dart';
import 'package:easy_language/core/api/api_repository.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:logger/logger.dart';

// TODO: move remote data source to repository (for simplicity) and use dio instead of http
abstract class UserRemoteDataSource {
  final ApiRepository dio;

  UserRemoteDataSource(this.dio);

  Future<UserModel> fetchUser({required UserModel userToFetch});

  Future<UserModel> editUser({
    required UserModel userToEdit,
    required Map<dynamic, dynamic> editMap,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  final ApiRepository dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> fetchUser({required UserModel userToFetch}) async {
    try {
      final Response<Map> response = await dio().get('$api/user');

      if (!response.ok || response.data == null) {
        Logger().e(response.data);
        Logger().e(response.statusCode);
        throw InfoFailure(
          errorMessage: (response.data ?? 'No data').toString(),
        );
      }

      final Map bodyMap = response.data!;

      return userToFetch.copyWithMap(bodyMap);
    } catch (e, stacktrace) {
      Logger().e(e);
      Logger().e(stacktrace);
      rethrow;
    }
  }

  @override
  Future<UserModel> editUser({
    required UserModel userToEdit,
    required Map<dynamic, dynamic> editMap,
  }) async {
    try {
      final Response<Map> response = await dio().patch(
        '$api/user',
        data: editMap,
      );

      if (!response.ok || response.data == null) {
        Logger().e(response.data);
        Logger().e(response.statusCode);
        throw InfoFailure(
          errorMessage: (response.data ?? 'No data').toString(),
        );
      }

      final Map bodyMap = response.data!;

      return userToEdit.copyWithMap(bodyMap);
    } catch (e, stacktrace) {
      Logger().e(e);
      Logger().e(stacktrace);
      rethrow;
    }
  }
}
