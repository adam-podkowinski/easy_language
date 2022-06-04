import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/utils.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> fetchUser({required UserModel userToFetch});

  Future<UserModel> editUser({
    required UserModel userToEdit,
    required Map<dynamic, dynamic> editMap,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<UserModel> fetchUser({required UserModel userToFetch}) async {
    try {
      final response = await http.get(
        Uri.parse('$api/user'),
        headers: headers(userToFetch.token),
      );

      final Map bodyMap = cast(jsonDecode(response.body));

      if (!response.ok) {
        Logger().e(response.body);
        Logger().e(response.statusCode);
        throw InfoFailure(errorMessage: response.body);
      }

      return userToFetch.copyWithMap({'user': bodyMap});
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
    final response = await http.patch(
      Uri.parse('$api/user'),
      body: jsonEncode(editMap),
      headers: headers(userToEdit.token),
    );

    final Map bodyMap = cast(jsonDecode(response.body));

    if (!response.ok) {
      Logger().e(response.body);
      Logger().e(response.statusCode);
      throw InfoFailure(errorMessage: response.body);
    }

    return userToEdit.copyWithMap({'user': bodyMap});
  }
}
