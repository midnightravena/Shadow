import '../../values/exports.dart';
import '../namespace.dart';

abstract class BooleanNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('from'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final Value value = call.argumentAt(0);
          return BooleanValue(value.isTruthy);
        },
      ),
    );
    namespace.declare('Boolean', value);
  }
}
