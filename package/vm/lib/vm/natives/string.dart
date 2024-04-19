import '../../values/exports.dart';
import '../namespace.dart';

abstract class StringNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('from'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          return StringValue(value);
        },
      ),
    );
    value.set(
      StringValue('fromCodeUnit'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final NumberValue value = call.argumentAt(0);
          return StringValue(String.fromCharCode(value.intValue));
        },
      ),
    );
    value.set(
      StringValue('fromCodeUnits'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final ListValue value = call.argumentAt(0);
          return StringValue(
            String.fromCharCodes(
              value.elements.map(
                (final Value x) => x.cast<NumberValue>().intValue,
              ),
            ),
          );
        },
      ),
    );
    namespace.declare('String', value);
  }
}
