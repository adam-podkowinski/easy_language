import 'package:easy_language/features/flashcards/domain/entities/flashcard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_picker/languages.dart';

// TODO: write tests for flashcard model
void main() {
  final tFlashcard = Flashcard(
    isTurned: false,
    wordId: 'id',
    wordLanguage: Languages.polish,
  );

  group('fromMap', () {
    test(
      'Should return a valid flashcard from a map',
      () async {},
    );
  });
}
