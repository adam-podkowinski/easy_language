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
}

class Word extends Equatable {
  final String wordForeign;
  final String wordTranslation;
  final DateTime editDate;
  final LearningStatus learningStatus;
  final int timesReviewed;

  const Word({
    required this.wordForeign,
    required this.wordTranslation,
    required this.editDate,
    this.learningStatus = LearningStatus.reviewing,
    this.timesReviewed = 0,
  });

  static const wordForeignId = 'wordForeign';
  static const wordTranslationId = 'wordTranslation';
  static const wordEditDateId = 'wordEditDate';
  static const learningStatusId = 'learningStatus';
  static const timesReviewedId = 'timesReviewed';

  factory Word.fromMap(Map<dynamic, dynamic> map) {
    return Word(
      wordForeign: cast(map[Word.wordForeignId]) ?? '',
      wordTranslation: cast(map[Word.wordTranslationId]) ?? '',
      learningStatus: LearningStatusExtension.fromString(
        cast(map[Word.learningStatusId]),
      ),
      timesReviewed: cast(map[Word.timesReviewedId]) ?? 0,
      editDate: DateTime.tryParse(
            cast(map[Word.wordEditDateId]),
          ) ??
          DateTime.now(),
    );
  }

  Word copyWithMap(Map<dynamic, dynamic> map) {
    return Word.fromMap({...toMap(), ...map});
  }

  Map<dynamic, dynamic> toMap() => {
        Word.wordForeignId: wordForeign,
        Word.wordTranslationId: wordTranslation,
        Word.wordEditDateId: editDate.toIso8601String(),
        Word.learningStatusId: learningStatus.statusToString,
        Word.timesReviewedId: timesReviewed,
      };

  @override
  List<Object?> get props => [
        wordForeign,
        wordTranslation,
        editDate,
        learningStatus,
        timesReviewed,
      ];
}
