class NativeException implements Exception {
  NativeException(this.message);

  final String message;

  @override
  String toString() => 'NativeException: $message';
}
