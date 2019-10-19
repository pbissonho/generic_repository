class RestException implements Exception {
  final String message;

  RestException(this.message);

  @override
  String toString() {
    return "RestException: Message: $message";
  }
}
