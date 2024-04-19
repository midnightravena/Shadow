import '../../errors/exports.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class NativeFunctionCall {
  NativeFunctionCall({
    required this.frame,
    required this.arguments,
  });

  final CallFrame frame;
  final List<Value> arguments;

  T argumentAt<T extends Value>(final int index) {
    final Value value =
        index < arguments.length ? arguments[index] : NullValue.value;
    if (!value.canCast<T>()) {
      throw RuntimeExpection.unexpectedArgumentType(
        index,
        Value.getKindFromType(T),
        value.kind,
      );
    }
    return value as T;
  }
}
