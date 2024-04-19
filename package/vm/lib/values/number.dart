import '../errors/exports.dart';
import 'exports.dart';

class NumberValue extends PrimitiveObjectValue {
  NumberValue(this.value);

  final double value;

  int get unsafeIntValue => value.toInt();

  int get intValue {
    if (value % 1 == 0) return value.toInt();
    throw RuntimeExpection.cannotConvertDoubleToInteger(value);
  }

  num get numValue {
    if (value % 1 == 0) return value.toInt();
    return value;
  }

  NumberValue get negate => NumberValue(-value);

  @override
  Value get(final Value key) {
    if (key is StringValue) {
      switch (key.value) {
        case 'sign':
          return NativeFunctionValue.sync(
            (final _) => NumberValue(value.sign),
          );

        case 'isFinite':
          return NativeFunctionValue.sync(
            (final _) => BooleanValue(value.isFinite),
          );

        case 'isInfinite':
          return NativeFunctionValue.sync(
            (final _) => BooleanValue(value.isInfinite),
          );

        case 'isNaN':
          return NativeFunctionValue.sync(
            (final _) => BooleanValue(value.isNaN),
          );

        case 'isNegative':
          return NativeFunctionValue.sync(
            (final _) => BooleanValue(value.isNegative),
          );

        case 'abs':
          return NativeFunctionValue.sync(
            (final _) => NumberValue(value.abs()),
          );

        case 'ceil':
          return NativeFunctionValue.sync(
            (final _) => NumberValue(value.ceilToDouble()),
          );

        case 'round':
          return NativeFunctionValue.sync(
            (final _) => NumberValue(value.roundToDouble()),
          );

        case 'truncate':
          return NativeFunctionValue.sync(
            (final _) => NumberValue(value.truncateToDouble()),
          );

        case 'toPrecisionString':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) => StringValue(
              value.toStringAsPrecision(
                call.argumentAt<NumberValue>(0).intValue,
              ),
            ),
          );

        case 'toRadixString':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) => StringValue(
              intValue.toRadixString(
                call.argumentAt<NumberValue>(0).intValue,
              ),
            ),
          );

        default:
      }
    }
    return super.get(key);
  }

  @override
  final ValueKind kind = ValueKind.number;

  @override
  NumberValue kClone() => NumberValue(value);

  @override
  String kToString() {
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toString();
  }

  @override
  bool get isTruthy => value != 0;

  @override
  int get kHashCode => value.hashCode;
}
