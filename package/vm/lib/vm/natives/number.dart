import '../../errors/native_exception.dart';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class NumberNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('infinity'),
      NumberValue(double.infinity),
    );
    value.set(
      StringValue('negativeInfinity'),
      NumberValue(double.negativeInfinity),
    );
    value.set(
      StringValue('NaN'),
      NumberValue(double.nan),
    );
    value.set(
      StringValue('maxFinite'),
      NumberValue(double.maxFinite),
    );
    value.set(
      StringValue('from'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return NumberValue(parsed);
          throw NativeException('Cannot parse "$value" to number');
        },
      ),
    );
    value.set(
      StringValue('fromOrNull'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return NumberValue(parsed);
          return NullValue.value;
        },
      ),
    );
    value.set(
      StringValue('fromRadix'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final NumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return NumberValue(parsed);
          throw NativeException('Cannot parse "$value" to number');
        },
      ),
    );
    value.set(
      StringValue('fromRadixOrNull'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final NumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return NumberValue(parsed);
          return NullValue.value;
        },
      ),
    );
    namespace.declare('Number', value);
  }
}
