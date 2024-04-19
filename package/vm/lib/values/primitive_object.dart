import 'exports.dart';

abstract class PrimitiveObjectValue extends Value {
  PrimitiveObjectValue({
    final Map<int, Value>? keys,
    final Map<int, Value>? values,
    final Map<String, dynamic>? internals,
  })  : keys = keys ?? <int, Value>{},
        values = values ?? <int, Value>{},
        internals = internals ?? <String, dynamic>{};

  final Map<int, Value> keys;
  final Map<int, Value> values;
  final Map<String, dynamic> internals;

  bool has(final Value key) => keys.containsKey(key.kHashCode);

  Value? getOrNull(final Value key) => values[key.kHashCode];

  Value get(final Value key) => getOrNull(key) ?? NullValue.value;

  void set(final Value key, final Value value) {
    final int hashCode = key.kHashCode;
    keys[hashCode] = key;
    values[hashCode] = value;
  }

  void delete(final Value key) {
    final int hashCode = key.kHashCode;
    keys.remove(hashCode);
    values.remove(hashCode);
  }

  List<MapEntry<Value, Value>> entries() {
    final List<MapEntry<Value, Value>> entries = <MapEntry<Value, Value>>[];
    for (final int x in keys.keys) {
      entries.add(MapEntry<Value, Value>(keys[x]!, values[x]!));
    }
    return entries;
  }

  Value kClone();
}
