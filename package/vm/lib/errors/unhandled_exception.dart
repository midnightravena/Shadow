class UnhandledExpection implements Exception {
  UnhandledExpection(this.message);

  final String message;

  @override
  String toString() => 'UnhandledExpection: $message';
}
