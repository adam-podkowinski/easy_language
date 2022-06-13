import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/main_app.dart';
import 'package:easy_language/features/user/presentation/pages/authenticate_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

enum TokenErrorType {
  tokenNotFound,
  refreshTokenHasExpired,
  invalidAccessToken,
  failedToRegenerateAccessToken
}

//TODO: show error when token is blank and requiresToken header is not set to false
class AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final Box _box;

  AuthInterceptor(this._dio, this._box);

  String? _getAccessToken() {
    return cast(_box.get('accessToken'));
  }

  String? _getRefreshToken() {
    return cast(_box.get('refreshToken'));
  }

  Future _saveAccessToken(String? token) async {
    await _box.put('accessToken', token);
  }

  Future _removeTokens() async {
    await _box.clear();
  }

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers["requiresToken"] == false) {
      // if the request doesn't need token, then just continue to the next interceptor
      options.headers.remove("requiresToken"); //remove the auxiliary header
      return handler.next(options);
    }

    // get tokens from local storage, you can use Hive or flutter_secure_storage
    final accessToken = _getAccessToken();
    final refreshToken = _getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      Logger().e('Token not found');
      _performLogout(_dio);

      // create custom dio error
      options.extra["tokenErrorType"] = TokenErrorType
          .tokenNotFound; // I use enum type, you can chage it to string
      final error = DioError(requestOptions: options);
      return handler.reject(error);
    }

    // check if tokens have already expired or not
    // I use jwt_decoder package
    // Note: ensure your tokens has "exp" claim
    final accessTokenHasExpired = JwtDecoder.isExpired(accessToken);
    final refreshTokenHasExpired = JwtDecoder.isExpired(refreshToken);

    var _refreshed = true;

    if (refreshTokenHasExpired) {
      _performLogout(_dio);

      // create custom dio error
      options.extra["tokenErrorType"] = TokenErrorType.refreshTokenHasExpired;
      final error = DioError(requestOptions: options);

      return handler.reject(error);
    } else if (accessTokenHasExpired) {
      // regenerate access token
      /* _dio.interceptors.requestLock.lock(); */
      _refreshed = await _regenerateAccessToken();
      /* _dio.interceptors.requestLock.unlock(); */
    }

    if (_refreshed) {
      // add access token to the request header
      options.headers["Authorization"] = "Bearer $accessToken";
      return handler.next(options);
    } else {
      // create custom dio error
      options.extra["tokenErrorType"] =
          TokenErrorType.failedToRegenerateAccessToken;
      final error = DioError(requestOptions: options);
      return handler.reject(error);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      // for some reasons the token can be invalidated before it is expired by the backend.
      // then we should navigate the user back to login page

      _performLogout(_dio);

      // create custom dio error
      err.type = DioErrorType.other;
      err.requestOptions.extra["tokenErrorType"] =
          TokenErrorType.invalidAccessToken;
    }

    return handler.next(err);
  }

  Future _performLogout(Dio dio) async {
    /* _dio.interceptors.requestLock.clear(); */
    /* _dio.interceptors.requestLock.lock(); */

    await _removeTokens(); // remove token from local storage

    // back to login page without using context
    // check this https://stackoverflow.com/a/53397266/9101876
    navigatorKey.currentState?.pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const AuthenticatePage(),
      ),
    );

    /* _dio.interceptors.requestLock.unlock(); */
  }

  /// return true if it is successfully regenerate the access token
  Future<bool> _regenerateAccessToken() async {
    try {
      final dio =
          Dio(); // should create new dio instance because the request interceptor is being locked

      // get refresh token from local storage
      final refreshToken = _getRefreshToken();

      // make request to server to get the new access token from server using refresh token
      final Response<Map> response = await dio.get(
        "$api/authentication/refresh",
        options: Options(headers: {"Authorization": "Bearer $refreshToken"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String? newAccessToken = cast(
          response.data!["accessToken"],
        ); // parse data based on your JSON structure
        _saveAccessToken(newAccessToken); // save to local storage
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // it means your refresh token no longer valid now, it may be revoked by the backend
        _performLogout(_dio);
        return false;
      } else {
        Logger().e(response.statusCode);
        return false;
      }
    } on DioError {
      return false;
    } catch (e) {
      return false;
    }
  }
}
