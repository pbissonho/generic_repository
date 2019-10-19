import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message = "";

  Failure(String message);

  @override
  List<Object> get props => [message];
}

// General failures
class RestFailure extends Failure {
  RestFailure(String message) : super(message);
}
