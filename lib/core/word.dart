import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';
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
  /// 10 variables
  final String id;
  final String wordForeign;
  final String wordTranslation;
  final LearningStatus learningStatus;
  final int timesReviewed;
  final Language language;
  final int order;
  final BigInt userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Word({
    required this.id,
    required this.wordForeign,
    required this.wordTranslation,
    required this.language,
    required this.order,
    required this.userId,
    this.learningStatus = LearningStatus.reviewing,
    this.timesReviewed = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  static const idId = 'id';
  static const wordForeignId = 'word_foreign';
  static const wordTranslationId = 'word_translation';
  static const languageId = 'language';
  static const learningStatusId = 'learning_status';
  static const timesReviewedId = 'times_reviewed';
  static const orderId = 'order_index';
  static const userIdId = 'user_id';
  static const createdAtId = 'created_at';
  static const updatedAtId = 'updated_at';

  factory Word.fromMap(Map<dynamic, dynamic> map) {
    return Word(
      id: cast(map[Word.idId]) ?? const Uuid().v1(),
      wordForeign: cast(map[Word.wordForeignId]) ?? '',
      wordTranslation: cast(map[Word.wordTranslationId]) ?? '',
      learningStatus: LearningStatusExtension.fromString(
        cast(map[Word.learningStatusId]),
      ),
      timesReviewed: cast(map[Word.timesReviewedId]) ?? 0,
      order: cast(map[Word.orderId]) ?? 0,
      userId: cast(map[Word.userIdId]) ?? BigInt.from(0),
      language: Language.fromIsoCode(
        cast(map[Word.languageId]) ?? Languages.english.isoCode,
      ),
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
        Word.orderId: order,
        Word.userIdId: userId,
        Word.languageId: language,
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
        order,
        language,
        createdAt,
        updatedAt,
      ];
}
