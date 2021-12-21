import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/user/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> fetchUser();

  Future<UserModel> editUser({
    required UserModel userToEdit,
    required Map<dynamic, dynamic> editMap,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<UserModel> fetchUser() async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> editUser({
    required UserModel userToEdit,
    required Map<dynamic, dynamic> editMap,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$api/user'),
        body: editMap,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToEdit.token}'
        },
      );

      final Map<dynamic, dynamic> bodyMap = cast(jsonDecode(response.body));

      if (!response.ok) {
        Logger().e(response.body);
        Logger().e(response.statusCode);
        throw UserUnauthenticatedFailure(response.body);
      }

      return userToEdit.copyWithMap(bodyMap);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
