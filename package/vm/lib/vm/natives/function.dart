import '../../values/exports.dart';
import '../namespace.dart';

abstract class FunctionNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('call'),
      NativeFunctionValue(
        (final NativeFunctionCall call) {
          final CallableValue fn = call.argumentAt(0);
          final ListValue arguments = call.argumentAt(1);
          return call.frame.callValue(fn, arguments.elements);
        },
      ),
    );
    namespace.declare('Function', value);
  }
}
