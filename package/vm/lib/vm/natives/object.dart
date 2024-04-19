import '../../values/exports.dart';
import '../namespace.dart';

abstract class ObjectNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('from'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final ObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    value.set(
      StringValue('fromEntries'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final ListValue value = call.argumentAt(0);
          final ObjectValue nValue = ObjectValue();
          for (final int x in value.keys.keys) {
            nValue.set(value.keys[x]!, value.values[x]!);
          }
          return nValue;
        },
      ),
    );
    value.set(
      StringValue('apply'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final PrimitiveObjectValue a = call.argumentAt(0);
          final PrimitiveObjectValue b = call.argumentAt(1);
          for (final int x in b.keys.keys) {
            a.set(b.keys[x]!, b.values[x]!);
          }
          return a;
        },
      ),
    );
    value.set(
      StringValue('entries'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final PrimitiveObjectValue value = call.argumentAt(0);
          return entries(value);
        },
      ),
    );
    value.set(
      StringValue('keys'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final PrimitiveObjectValue value = call.argumentAt(0);
          return ListValue(value.keys.values.toList());
        },
      ),
    );
    value.set(
      StringValue('values'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final PrimitiveObjectValue value = call.argumentAt(0);
          return ListValue(value.values.values.toList());
        },
      ),
    );
    value.set(
      StringValue('clone'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final PrimitiveObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    value.set(
      StringValue('deleteProperty'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final PrimitiveObjectValue value = call.argumentAt(0);
          final Value key = call.argumentAt(1);
          value.delete(key);
          return NullValue.value;
        },
      ),
    );
    namespace.declare('Object', value);
  }

  static ListValue entries(final PrimitiveObjectValue value) {
    final ListValue result = ListValue();
    for (final int x in value.keys.keys) {
      result.push(
        ListValue(<Value>[
          value.keys[x]!,
          value.values[x]!,
        ]),
      );
    }
    return result;
  }
}
