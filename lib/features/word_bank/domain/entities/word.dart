import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String wordForeign;
  final String wordTranslation;

  const Word({required this.wordForeign, required this.wordTranslation});

  @override
  List<Object?> get props => [wordForeign, wordTranslation];
}
