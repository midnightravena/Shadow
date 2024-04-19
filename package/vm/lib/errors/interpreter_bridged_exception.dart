import '../values/exports.dart';

class InterpreterBridgedException implements Exception {
  InterpreterBridgedException(this.error);

  final ExceptionValue error;
  
  @override
  String toString() =>
      'InterpreterBridgedException: ${error.toCustomString(includePrefix: false)}';
}
