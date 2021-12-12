import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/features/flashcard/domain/entities/flashcard.dart';
import 'package:easy_language/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:easy_language/features/word_bank/domain/entities/dictionary.dart';
import 'package:flutter/cupertino.dart';
import 'package:language_picker/languages.dart';

class FlashcardProvider extends ChangeNotifier {
  final FlashcardRepository flashcardRepository;

  bool loading = true;

  Flashcard? currentFlashcard;
  FlashcardFailure? flashcardFailure;

  FlashcardProvider({
    required this.flashcardRepository,
  });

  void _prepareMethod() {
    loading = true;
    flashcardFailure = null;
  }

  void _finishMethod() {
    loading = false;
    notifyListeners();
  }

  Future turnCurrentFlashcard() async {
    _prepareMethod();

    final result = await flashcardRepository.turnCurrentFlashcard();

    result.fold(
      (l) {
        if (l is FlashcardFailure) {
          flashcardFailure = l;
          if (l is FlashcardGetFailure) {
            currentFlashcard = null;
          }
        }
      },
      (r) => currentFlashcard = r,
    );

    _finishMethod();
  }

  Future getNextFlashcard(
    Dictionary? dictionary, {
    Language? language,
    bool? init,
  }) async {
    _prepareMethod();

    if (dictionary == null) {
      return;
    }

    final result = await flashcardRepository.getNextFlashcard(
      dictionary,
      init: init,
    );

    result.fold(
      (l) {
        if (l is FlashcardFailure) {
          flashcardFailure = l;
          if (l is FlashcardGetFailure) {
            currentFlashcard = null;
          }
        }
      },
      (r) => currentFlashcard = r,
    );

    _finishMethod();
  }

  Future fetchFlashcard() async {
    _prepareMethod();

    final result = await flashcardRepository.fetchFlashcardRemotely();

    result.fold(
      (l) {
        if (l is FlashcardFailure) {
          flashcardFailure = l;
          if (l is FlashcardGetFailure) {
            currentFlashcard = null;
          }
        }
      },
      (r) => currentFlashcard = r,
    );

    _finishMethod();
  }

  Future saveFlashcard() async {
    await flashcardRepository.saveFlashcard();
  }
}
