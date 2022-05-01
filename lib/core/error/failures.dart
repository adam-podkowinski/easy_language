import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class InfoFailure extends Failure {
  final String errorMessage;
  final bool showErrorMessage;

  InfoFailure({
    this.errorMessage = 'Unknown error!',
    this.showErrorMessage = true,
  });

  @override
  List<Object?> get props => [errorMessage];
}
