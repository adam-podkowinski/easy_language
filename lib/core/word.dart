import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

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
  final String wordForeign;
  final String wordTranslation;
  final DateTime editDate;
  final LearningStatus learningStatus;
  final int timesReviewed;
  final String id;

  const Word({
    required this.wordForeign,
    required this.wordTranslation,
    required this.editDate,
    required this.id,
    this.learningStatus = LearningStatus.reviewing,
    this.timesReviewed = 0,
  });

  static const wordForeignId = 'wordForeign';
  static const wordTranslationId = 'wordTranslation';
  static const wordEditDateId = 'wordEditDate';
  static const learningStatusId = 'learningStatus';
  static const timesReviewedId = 'timesReviewed';
  static const idId = 'id';

  factory Word.fromMap(Map<dynamic, dynamic> map) {
    return Word(
      id: cast(map[Word.idId]) ?? const Uuid().v1(),
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
        Word.idId: id,
      };

  @override
  List<Object?> get props => [
        wordForeign,
        wordTranslation,
        editDate,
        learningStatus,
        timesReviewed,
        id,
      ];
}
