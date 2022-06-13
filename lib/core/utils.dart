import 'package:dio/dio.dart';
import 'package:language_picker/languages.dart';
import 'package:logger/logger.dart';

Language? languageFromName(String name) {
  try {
    return Languages.defaultLanguages
        .firstWhere((element) => element.name == name);
  } catch (e) {
    Logger().i('Could not find a language from a given name');
    return null;
  }
}

String simplifyString(String val) {
  return val
      .toLowerCase()
      .trim()
      .replaceAll(' ', '')
      .replaceAll(',', '')
      .replaceAll('.', '')
      .replaceAll("'", '')
      .replaceAll(':', '')
      .replaceAll('"', '')
      .replaceAll('-', '');
}

Options options() {
  return Options(
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );
}

Map<String, String> headers([String? token]) {
  return {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token'
  };
}

// TODO: to implement (check before each request jwt expires at) and add to dio interceptors
Future<Response> handleRefreshToken(
  Future<Response> Function() function,
) {
  return function();
}
