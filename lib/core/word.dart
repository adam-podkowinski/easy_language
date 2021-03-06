import 'package:dartz/dartz.dart';
import 'package:easy_language/core/constants.dart';
import 'package:equatable/equatable.dart';

enum LearningStatus {
  reviewing(_reviewingId),
  learning(_learningId),
  mastered(_masteredId);

  final String value;
  const LearningStatus(this.value);

  static const _reviewingId = 'reviewing';
  static const _learningId = 'learning';
  static const _masteredId = 'mastered';

  static LearningStatus fromString(String? value) {
    switch (value) {
      case _learningId:
        return LearningStatus.learning;
      case _masteredId:
        return LearningStatus.mastered;
      default:
        return LearningStatus.reviewing;
    }
  }

  static LearningStatus fromTimesReviewed(int timesReviewed) {
    if (timesReviewed <= 1) {
      return LearningStatus.reviewing;
    } else if (timesReviewed <= 9) {
      return LearningStatus.learning;
    } else {
      return LearningStatus.mastered;
    }
  }
}

class Word extends Equatable {
  final int id;
  final String wordForeign;
  final String wordTranslation;
  final LearningStatus learningStatus;
  final int timesReviewed;
  final DateTime updatedAt;
  final bool favorite;

  const Word({
    required this.id,
    required this.wordForeign,
    required this.wordTranslation,
    required this.learningStatus,
    required this.timesReviewed,
    required this.updatedAt,
    required this.favorite,
  });

  static const dictionaryIdId = 'dictionaryId';
  static const wordForeignId = 'wordForeign';
  static const wordTranslationId = 'wordTranslation';
  static const learningStatusId = 'learningStatus';
  static const timesReviewedId = 'timesReviewed';
  static const favoriteId = 'favorite';

  factory Word.fromMap(Map map) {
    final favoriteVar = map[Word.favoriteId];
    bool favorite = false;
    if (favoriteVar is bool) {
      favorite = favoriteVar;
    } else if (favoriteVar is num) {
      favorite = favoriteVar == 1;
    }

    return Word(
      id: cast(map[idId]) ?? 0,
      wordForeign: cast(map[Word.wordForeignId]) ?? '',
      wordTranslation: cast(map[Word.wordTranslationId]) ?? '',
      learningStatus: LearningStatus.fromString(
        cast(map[Word.learningStatusId]),
      ),
      timesReviewed: cast(map[Word.timesReviewedId]) ?? 0,
      favorite: favorite,
      updatedAt: DateTime.parse(
        cast(map[updatedAtId]),
      ),
    );
  }

  Word copyWithMap(Map map) {
    return Word.fromMap({...toMap(), ...map});
  }

  Map toMap() => {
        idId: id,
        updatedAtId: updatedAt.toIso8601String(),
        Word.wordForeignId: wordForeign,
        Word.wordTranslationId: wordTranslation,
        Word.learningStatusId: learningStatus.value,
        Word.timesReviewedId: timesReviewed,
        Word.favoriteId: favorite,
      };

  @override
  List<Object?> get props => [
        id,
        wordForeign,
        wordTranslation,
        learningStatus,
        timesReviewed,
        favorite,
        updatedAt,
      ];
}
