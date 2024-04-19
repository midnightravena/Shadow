import 'dart:async';
import '../../values/exports.dart';
import '../exports.dart';

abstract class FiberNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('wait'),
      NativeFunctionValue.async(
        (final NativeFunctionCall call) async {
          final NumberValue value = call.argumentAt(0);
          await Future<void>.delayed(
            Duration(milliseconds: value.unsafeIntValue),
          );
          return NullValue.value;
        },
      ),
    );
    value.set(
      StringValue('runConcurrently'),
      NativeFunctionValue.async(
        (final NativeFunctionCall call) async {
          final ListValue fns = call.argumentAt(0);
          final List<Value> result = await Future.wait(
            fns.elements.map(
              (final Value x) async {
                Value value = call.frame.callValue(x, <Value>[]).unwrapUnsafe();
                while (value is UnawaitedValue) {
                  value = await value.execute(call.frame).unwrapUnsafe();
                }
                return value;
              },
            ),
          );
          return ListValue(result);
        },
      ),
    );
    namespace.declare('Fiber', value);
  }
}
