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
