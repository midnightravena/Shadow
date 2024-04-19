import 'exports.dart';

class ExceptionValue extends PrimitiveObjectValue {
  ExceptionValue(this.message, this.stackTrace, [this.dartStackTrace]);

  final String message;
  final String stackTrace;
  final String? dartStackTrace;

  @override
  Value get(final Value key) {
    if (key is StringValue) {
      switch (key.value) {
        case 'message':
          return StringValue(message);
        case 'stackTrace':
          return StringValue(stackTrace);
        default:
      }
    }
    return super.get(key);
  }

  @override
  final ValueKind kind = ValueKind.exception;

  @override
  ExceptionValue kClone() =>
      ExceptionValue(message, stackTrace, dartStackTrace);

  @override
  String kToString() => 'Exception: $message\nStack Trace:\n$stackTrace';

  String toCustomString({
    final bool includePrefix = true,
  }) {
    final StringBuffer buffer = StringBuffer();
    if (includePrefix) {
      buffer.write('ExceptionValue: ');
    }
    buffer.writeln(message);
    buffer.writeln('Shadow Stack Trace:');
    buffer.writeln(stackTrace);
    if (dartStackTrace != null) {
      buffer.writeln('--- Previous Dart Stack Trace:');
      buffer.writeln(dartStackTrace.toString().trimRight());
      buffer.writeln('--- [end] Previous Dart Stack Trace');
    }
    return buffer.toString();
  }

  @override
  String toString() => toCustomString();

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => Object.hash(message, stackTrace, dartStackTrace);
}
