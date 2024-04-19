import '../../values/exports.dart';
import '../exports.dart';

abstract class UnawaitedNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('value'),
      NativeFunctionValue.async(
        (final NativeFunctionCall call) async {
          final Value value = call.argumentAt(0);
          return value;
        },
      ),
    );
    namespace.declare('Unawaited', value);
  }
}
