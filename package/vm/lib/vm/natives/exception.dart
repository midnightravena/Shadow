import '../../values/exports.dart';
import '../namespace.dart';

abstract class ExceptionNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('new'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue message = call.argumentAt(0);
          final Value stackTrace = call.argumentAt(1);
          return ExceptionValue(
            message.value,
            stackTrace is NullValue
                ? call.frame.getStackTrace()
                : stackTrace.kToString(),
          );
        },
      ),
    );
    namespace.declare('Exception', value);
  }
}
