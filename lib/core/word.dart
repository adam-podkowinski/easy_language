import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Word extends Equatable {
  final String wordForeign;
  final String wordTranslation;
  final DateTime editDate;

  const Word({
    required this.wordForeign,
    required this.wordTranslation,
    required this.editDate,
  });

  static const wordForeignId = 'wordForeign';
  static const wordTranslationId = 'wordTranslation';
  static const wordEditDateId = 'wordEditDate';

  factory Word.fromMap(Map<dynamic, dynamic> map) {
    return Word(
      wordForeign: cast(map[Word.wordForeignId]) ?? '',
      wordTranslation: cast(map[Word.wordTranslationId]) ?? '',
      editDate: DateTime.tryParse(
            cast(map[Word.wordEditDateId]),
          ) ??
          DateTime.now(),
    );
  }

  Word copyWithMap(Map<dynamic, dynamic> map) {
    final newMap = {...toMap(), ...map};
    return Word.fromMap(newMap);
  }

  Map<dynamic, dynamic> toMap() => {
        Word.wordForeignId: wordForeign,
        Word.wordTranslationId: wordTranslation,
        Word.wordEditDateId: editDate.toIso8601String(),
      };

  @override
  List<Object?> get props => [wordForeign, wordTranslation, editDate];
}
