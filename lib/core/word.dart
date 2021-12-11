import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

enum LearningStatus { learning, reviewing, mastered }

extension LearningStatusExtension on LearningStatus {
  static const learningId = 'learning';
  static const reviewingId = 'reviewing';
  static const masteredId = 'mastered';

  String get statusToString {
    switch (this) {
      case LearningStatus.learning:
        return learningId;
      case LearningStatus.reviewing:
        return reviewingId;
      case LearningStatus.mastered:
        return masteredId;
    }
  }

  static LearningStatus fromString(String? value) {
    switch (value) {
      case learningId:
        return LearningStatus.learning;
      case masteredId:
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
  /// 10 variables
  final int id;
  final String wordForeign;
  final String wordTranslation;
  final LearningStatus learningStatus;
  final int timesReviewed;
  final int dictionaryId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Word({
    required this.id,
    required this.wordForeign,
    required this.wordTranslation,
    required this.dictionaryId,
    required this.userId,
    this.learningStatus = LearningStatus.reviewing,
    this.timesReviewed = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  static const idId = 'id';
  static const wordForeignId = 'word_foreign';
  static const wordTranslationId = 'word_translation';
  static const learningStatusId = 'learning_status';
  static const timesReviewedId = 'times_reviewed';
  static const userIdId = 'user_id';
  static const dictionaryIdId = 'dictionary_id';
  static const createdAtId = 'created_at';
  static const updatedAtId = 'updated_at';

  factory Word.fromMap(Map<dynamic, dynamic> map) {
    return Word(
      id: cast(map[Word.idId]) ?? 0,
      wordForeign: cast(map[Word.wordForeignId]) ?? '',
      wordTranslation: cast(map[Word.wordTranslationId]) ?? '',
      learningStatus: LearningStatusExtension.fromString(
        cast(map[Word.learningStatusId]),
      ),
      timesReviewed: cast(map[Word.timesReviewedId]) ?? 0,
      userId: cast(map[Word.userIdId]) ?? 0,
      dictionaryId: cast(map[Word.dictionaryIdId]) ?? 0,
      createdAt: DateTime.tryParse(
            cast(map[Word.createdAtId]),
          ) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
            cast(map[Word.updatedAtId]),
          ) ??
          DateTime.now(),
    );
  }

  Word copyWithMap(Map<dynamic, dynamic> map) {
    return Word.fromMap({...toMap(), ...map});
  }

  Map<dynamic, dynamic> toMap() => {
        Word.idId: id,
        Word.wordForeignId: wordForeign,
        Word.wordTranslationId: wordTranslation,
        Word.learningStatusId: learningStatus.statusToString,
        Word.timesReviewedId: timesReviewed,
        Word.userIdId: userId,
        Word.dictionaryIdId: dictionaryId,
        Word.createdAtId: createdAt.toIso8601String(),
        Word.updatedAtId: updatedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        wordForeign,
        wordTranslation,
        learningStatus,
        timesReviewed,
        userId,
        dictionaryId,
        createdAt,
        updatedAt,
      ];
}
