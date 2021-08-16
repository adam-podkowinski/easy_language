import 'package:equatable/equatable.dart';
import 'package:language_picker/languages.dart';

class Flashcard extends Equatable {
  final bool isTurned;
  final int wordIndex;
  final Language wordLanguage;

  const Flashcard({
    required this.isTurned,
    required this.wordIndex,
    required this.wordLanguage,
  });

  @override
  List<Object?> get props => [
        isTurned,
        wordIndex,
        wordLanguage,
      ];
}
