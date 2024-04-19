import '../../vm/exports.dart';
import '../exports.dart';

typedef NativeExecuteFunction = InterpreterResult Function(
  NativeFunctionCall call,
);

typedef NativeSyncFunction = Value Function(
  NativeFunctionCall call,
);

typedef NativeAsyncFunction = Future<Value> Function(
  NativeFunctionCall call,
);

class NativeFunctionValue extends PrimitiveObjectValue
    implements CallableValue {
  NativeFunctionValue(this.function);

  factory NativeFunctionValue.sync(
    final NativeSyncFunction function,
  ) =>
      NativeFunctionValue(convertSyncFunction(function));

  factory NativeFunctionValue.async(
    final NativeAsyncFunction function,
  ) =>
      NativeFunctionValue(convertAsyncFunction(function));

  final NativeExecuteFunction function;

  InterpreterResult execute(final NativeFunctionCall call) {
    final InterpreterResult result = function(call);
    return result;
  }

  @override
  final ValueKind kind = ValueKind.nativeFunction;

  @override
  NativeFunctionValue kClone() => NativeFunctionValue(function);

  @override
  String kToString() => '<native function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => function.hashCode;

  static NativeExecuteFunction convertSyncFunction(
    final NativeSyncFunction function,
  ) =>
      (final NativeFunctionCall call) {
        try {
          final Value value = function(call);
          return InterpreterResult.success(value);
        } catch (err, stackTrace) {
          return FunctionValueUtils.handleException(
            call.frame,
            err,
            stackTrace,
          );
        }
      };

  static NativeExecuteFunction convertAsyncFunction(
    final NativeAsyncFunction function,
  ) =>
      (final NativeFunctionCall call) {
        final Value value = UnawaitedValue(
          call.arguments,
          wrapAsyncFunction(function),
        );
        return InterpreterResult.success(value);
      };

  static UnawaitedFunction wrapAsyncFunction(
    final NativeAsyncFunction function,
  ) =>
      (final NativeFunctionCall call) async {
        try {
          final Value value = await function(call);
          return InterpreterResult.success(value);
        } catch (err, stackTrace) {
          return FunctionValueUtils.handleException(
            call.frame,
            err,
            stackTrace,
          );
        }
      };
}
