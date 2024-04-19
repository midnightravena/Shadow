import '../../values/exports.dart';
import '../namespace.dart';

abstract class GlobalsNatives {
  static void bind(final Namespace namespace) {
    namespace.declare(
      'typeof',
      NativeFunctionValue.sync((final NativeFunctionCall call) {
        final Value value = call.argumentAt(0);
        return StringValue(value.kind.code);
      }),
    );
  }
}
