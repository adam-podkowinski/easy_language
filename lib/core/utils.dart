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

Map<String, String> headers([String? token]) {
  return {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token'
  };
}
