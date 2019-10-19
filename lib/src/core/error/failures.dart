import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class TestFailure extends Failure {
  final String userMessage = "";

  @override
  List<Object> get props => [userMessage];
}

// General failures
class RestFailure extends Failure {
  final String message;

  RestFailure(this.message);
  @override
  List<Object> get props => [message];
}
