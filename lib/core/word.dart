import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'constants.dart';

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
  /// 8 variables
  final int id;
  final String wordForeign;
  final String wordTranslation;
  final LearningStatus learningStatus;
  final int timesReviewed;
  final int dictionaryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Word({
    required this.id,
    required this.wordForeign,
    required this.wordTranslation,
    required this.dictionaryId,
    this.learningStatus = LearningStatus.reviewing,
    this.timesReviewed = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  static const dictionaryIdId = 'dictionary_id';
  static const wordForeignId = 'word_foreign';
  static const wordTranslationId = 'word_translation';
  static const learningStatusId = 'learning_status';
  static const timesReviewedId = 'times_reviewed';

  factory Word.fromMap(Map<dynamic, dynamic> map) {
    return Word(
      id: cast(map[idId]) ?? 0,
      wordForeign: cast(map[Word.wordForeignId]) ?? '',
      wordTranslation: cast(map[Word.wordTranslationId]) ?? '',
      learningStatus: LearningStatusExtension.fromString(
        cast(map[Word.learningStatusId]),
      ),
      timesReviewed: cast(map[Word.timesReviewedId]) ?? 0,
      dictionaryId: cast(map[Word.dictionaryIdId]) ?? 0,
      createdAt: DateTime.tryParse(
            cast(map[createdAtId]),
          ) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
            cast(map[updatedAtId]),
          ) ??
          DateTime.now(),
    );
  }

  Word copyWithMap(Map<dynamic, dynamic> map) {
    return Word.fromMap({...toMap(), ...map});
  }

  Map<dynamic, dynamic> toMap() => {
        idId: id,
        createdAtId: createdAt.toIso8601String(),
        updatedAtId: updatedAt.toIso8601String(),
        Word.wordForeignId: wordForeign,
        Word.wordTranslationId: wordTranslation,
        Word.learningStatusId: learningStatus.statusToString,
        Word.timesReviewedId: timesReviewed,
        Word.dictionaryIdId: dictionaryId,
      };

  @override
  List<Object?> get props => [
        id,
        wordForeign,
        wordTranslation,
        learningStatus,
        timesReviewed,
        dictionaryId,
        createdAt,
        updatedAt,
      ];
}
