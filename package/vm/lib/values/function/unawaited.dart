import '../../vm/exports.dart';
import '../exports.dart';

typedef UnawaitedFunction = Future<InterpreterResult> Function(
  NativeFunctionCall call,
);

class UnawaitedValue extends PrimitiveObjectValue {
  UnawaitedValue(this.arguments, this.function);

  final List<Value> arguments;
  final UnawaitedFunction function;

  Future<InterpreterResult> execute(final CallFrame frame) async {
    try {
      final NativeFunctionCall call = NativeFunctionCall(
        arguments: arguments,
        frame: frame,
      );
      final InterpreterResult result = await function(call);
      return result;
    } catch (err, stackTrace) {
      return FunctionValueUtils.handleException(
        frame,
        err,
        stackTrace,
      );
    }
  }

  @override
  final ValueKind kind = ValueKind.unawaited;

  @override
  UnawaitedValue kClone() => UnawaitedValue(arguments, function);

  @override
  String kToString() => '<unawaited>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => function.hashCode;
}
