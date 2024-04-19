import '../errors/exports.dart';
import '../values/exports.dart';

enum InterpreterResultState {
  success,
  fail,
}

class InterpreterResult {
  const InterpreterResult._(this.state, this.value);

  factory InterpreterResult.success(final Value value) =>
      InterpreterResult._(InterpreterResultState.success, value);

  factory InterpreterResult.fail(final ExceptionValue value) =>
      InterpreterResult._(InterpreterResultState.fail, value);

  final InterpreterResultState state;
  final Value value;

  ExceptionValue get error => value.cast();

  bool get isSuccess => state == InterpreterResultState.success;
  bool get isFailure => state == InterpreterResultState.fail;
}

extension ValueInterpreterResultUtils on InterpreterResult {
  Value unwrapUnsafe() {
    if (isFailure) {
      throw InterpreterBridgedException(error);
    }
    return value;
  }
}

extension ValueFutureInterpreterResultUtils on Future<InterpreterResult> {
  Future<Value> unwrapUnsafe() async {
    final InterpreterResult result = await this;
    return result.unwrapUnsafe();
  }
}
