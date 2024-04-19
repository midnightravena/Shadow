import 'exports.dart';

class ObjectValue extends PrimitiveObjectValue {
  ObjectValue({
    super.keys,
    super.values,
  });

  @override
  final ValueKind kind = ValueKind.object;

  @override
  ObjectValue kClone() => ObjectValue(
        keys: Map<int, Value>.of(keys),
        values: Map<int, Value>.of(values),
      );

  @override
  String kToString() {
    final List<String> stringValues = <String>[];
    for (final int x in keys.keys) {
      final String key = keys[x]!.kToString();
      final String value = values[x]!.kToString();
      stringValues.add('$key: $value');
    }
    return '{${stringValues.join(', ')}}';
  }

  @override
  bool get isTruthy => values.isNotEmpty;

  @override
  int get kHashCode => values.hashCode;
}
