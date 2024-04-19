import 'exports.dart';

class NullValue extends Value {
  NullValue._();

  @override
  bool get isTruthy => false;

  @override
  int get kHashCode => null.hashCode;

  @override
  final ValueKind kind = ValueKind.nullValue;

  @override
  String kToString() => 'null';

  static final NullValue value = NullValue._();
}
