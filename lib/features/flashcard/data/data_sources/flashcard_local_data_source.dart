import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/exceptions.dart';
import 'package:easy_language/features/flashcard/data/models/flashcard_model.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

abstract class FlashcardLocalDataSource {
  Future<FlashcardModel> getLocalFlashcard();

  Future cacheCurrentFlashcard(FlashcardModel flashcardModel);
}

class FlashcardLocalDataSourceImpl implements FlashcardLocalDataSource {
  final Box flashcardBox;

  FlashcardLocalDataSourceImpl({required this.flashcardBox});

  @override
  Future cacheCurrentFlashcard(FlashcardModel flashcardModel) async {
    try {
      await flashcardBox.put(cachedCurrentFlashcardId, flashcardModel.toMap());
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }

  @override
  Future<FlashcardModel> getLocalFlashcard() async {
    try {
      if (flashcardBox.isEmpty) {
        throw CacheException();
      } else {
        final dbMap = flashcardBox.get(cachedCurrentFlashcardId);
        return FlashcardModel.fromMap(cast(dbMap));
      }
    } catch (e) {
      Logger().e(e);
      throw CacheException();
    }
  }
}
