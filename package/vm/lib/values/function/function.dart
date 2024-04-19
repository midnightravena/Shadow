import '../../bytecode.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class FunctionValue extends PrimitiveObjectValue implements CallableValue {
  FunctionValue({
    required this.constant,
    required this.namespace,
  });

  final FunctionConstant constant;
  final Namespace namespace;

  @override
  Value get(final Value key) {
    if (key is StringValue) {
      switch (key.value) {
        case 'call':
          return NativeFunctionValue(
            (final NativeFunctionCall call) {
              final ListValue arguments = call.argumentAt(0);
              return call.frame.callValue(this, arguments.elements);
            },
          );
      }
    }
    return super.get(key);
  }

  bool get isAsync => constant.isAsync;

  @override
  final ValueKind kind = ValueKind.function;

  @override
  FunctionValue kClone() =>
      FunctionValue(constant: constant, namespace: namespace);

  @override
  String kToString() => '<function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
