import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/main_app.dart';
import 'package:easy_language/features/user/domain/repositories/user_repository.dart';
import 'package:easy_language/injection_container.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

enum TokenErrorType {
  tokenNotFound,
  refreshTokenHasExpired,
  invalidAccessToken,
  failedToRegenerateAccessToken
}

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
      // If the request doesn't need an accessToken just continue
      options.headers.remove("requiresToken");
      return handler.next(options);
    }

    var accessToken = _getAccessToken();
    final refreshToken = _getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      Logger().e(
        'Token not found: acceessToken: ($accessToken), refreshToken: ($refreshToken)',
      );
      _performLogout(_dio);

      final error = DioError(requestOptions: options);
      return handler.reject(error);
    }

    Logger().i('Checking if token is expired: $accessToken');
    final accessTokenHasExpired = JwtDecoder.isExpired(accessToken);
    final refreshTokenHasExpired = JwtDecoder.isExpired(refreshToken);

    var _refreshed = true;

    if (refreshTokenHasExpired) {
      _performLogout(_dio);

      Logger().e('Refresh token has expired');

      return handler.reject(
        DioError(
          requestOptions: options,
          error: 'Refresh token has expired. Log in again.',
        ),
      );
    } else if (accessTokenHasExpired) {
      // regenerate access token
      accessToken = await _regenerateAccessToken();
    }

    _refreshed = accessToken != null;

    if (_refreshed) {
      // add access token to the request header
      Logger().i('Adding access token to the request header: $accessToken');
      options.headers["Authorization"] = "Bearer $accessToken";
      return handler.next(options);
    } else {
      Logger().e('Failed to regenerate access token.');
      final error = DioError(requestOptions: options);
      return handler.reject(error);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Logger().i('Error: $err');
    _performLogout(_dio);
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      _performLogout(_dio);
    }

    return handler.next(err);
  }

  Future _performLogout(Dio dio) async {
    Logger().i('Logging out...');
    await _removeTokens();

    await sl<UserRepository>().logout();

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      authenticatePageId,
      (_) => false,
    );
  }

  /// return new access token if it is successfully regeneratated (otherwise return null)
  Future<String?> _regenerateAccessToken() async {
    try {
      Logger().i('Regenerating access token');
      // should create new dio instance because the interceptor is locked
      final dio = Dio();

      final refreshToken = _getRefreshToken();

      final Response<Map> response = await dio.get(
        "$api/authentication/refresh",
        options: Options(headers: {"Authorization": "Bearer $refreshToken"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Logger().i('Saving new acceess token ${response.data!['accessToken']}');
        final String? newAccessToken = cast(
          response.data!["accessToken"],
        );
        await _saveAccessToken(newAccessToken);
        return newAccessToken;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Logger().e('Could not refresh token!');
        _performLogout(_dio);
        return null;
      } else {
        Logger().e(response.statusCode);
        return null;
      }
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
  }
}
