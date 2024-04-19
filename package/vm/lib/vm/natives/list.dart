import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../exports.dart';

abstract class ListNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('from'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final Value value = call.argumentAt(0);
          if (value is ListValue) {
            return value.kClone();
          }
          if (value is PrimitiveObjectValue) {
            final PrimitiveObjectValue obj = call.argumentAt(0);
            return BeizeObjectNatives.entries(obj);
          }
          throw NativeException(
            'Cannot create list from "${value.kind}"',
          );
        },
      ),
    );
    value.set(
      StringValue('generate'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final int length = call.argumentAt<NumberValue>(0).intValue;
          final CallableValue predicate = call.argumentAt(1);
          final ListValue result = ListValue();
          for (int i = 0; i < length; i++) {
            result.push(
              call.frame.callValue(
                predicate,
                <Value>[NumberValue(i.toDouble())],
              ).unwrapUnsafe(),
            );
          }
          return result;
        },
      ),
    );
    value.set(
      StringValue('filled'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final int length = call.argumentAt<NumberValue>(0).intValue;
          final Value value = call.argumentAt(1);
          final ListValue result = ListValue(List<Value>.filled(length, value));
          return result;
        },
      ),
    );
    namespace.declare('List', value);
  }
}
