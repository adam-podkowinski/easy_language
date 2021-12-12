import 'package:easy_language/features/flashcard/data/models/flashcard_model.dart';

abstract class FlashcardRemoteDataSource {
  Future<FlashcardModel> fetchFlashcard();

  Future<void> saveFlashcard(FlashcardModel flashcardToCache);
}

class FlashcardRemoteDataSourceImpl implements FlashcardRemoteDataSource {
  @override
  Future<FlashcardModel> fetchFlashcard() {
    // TODO: implement fetchFlashcard
    throw UnimplementedError();
  }

  @override
  Future<void> saveFlashcard(FlashcardModel flashcardToCache) {
    // TODO: implement saveFlashcard
    throw UnimplementedError();
  }
}
