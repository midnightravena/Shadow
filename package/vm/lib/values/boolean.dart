import 'exports.dart';

class BooleanValue extends BeizePrimitiveObjectValue {
  
  factory BooleanValue(final bool value) => value ? trueValue : falseValue;
  BooleanValue._(this.value);

  final bool value;

  BooleanValue get inversed => BooleanValue(!value);

  @override
  final BeizeValueKind kind = BeizeValueKind.boolean;

  @override
  BooleanValue kClone() => BooleanValue(value);

  @override
  String kToString() => value.toString();

  @override
  bool get isTruthy => value;

  @override
  int get kHashCode => value.hashCode;

  static final BooleanValue trueValue = BooleanValue._(true);
  static final BooleanValue falseValue = BooleanValue._(false);
}
