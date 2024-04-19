import '../vm/exports.dart';
import 'exports.dart';

class ModuleValue extends PrimitiveObjectValue {
  ModuleValue(this.namespace);

  final Namespace namespace;

  @override
  Value get(final Value key) {
    if (key is StringValue) {
      final Value? value = namespace.lookupOrNull(key.value);
      if (value != null) return value;
    }
    return super.get(key);
  }

  @override
  void set(final Value key, final Value value) {
    if (key is StringValue) {
      final Value? existingValue = namespace.lookupOrNull(key.value);
      if (existingValue != null) {
        namespace.assign(key.value, value);
      }
    }
    return super.set(key, value);
  }

  @override
  final ValueKind kind = ValueKind.module;

  @override
  ModuleValue kClone() => ModuleValue(namespace);

  @override
  String kToString() => kind.code;

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => namespace.hashCode;
}
