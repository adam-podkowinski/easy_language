import 'package:easy_language/features/word_bank/domain/entities/word.dart';
import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class WordBank extends Equatable {
  final Map<Language, List<Word>> dictionaries;

  const WordBank({required this.dictionaries});

  @override
  List<Object?> get props => [dictionaries];
}
