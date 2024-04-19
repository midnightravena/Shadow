import '../errors/exports.dart';
import 'exports.dart';

abstract class Value {
  ValueKind get kind;

  String kToString();
  bool kEquals(final Value other) => other.kHashCode == kHashCode;

  T cast<T extends Value>() {
    if (canCast<T>()) return this as T;
    throw RuntimeExpection.cannotCastTo(getKindFromType(T), kind);
  }

  bool canCast<T extends Value>() {
    if (T == Value) return true;
    if (T == PrimitiveObjectValue) {
      return this is PrimitiveObjectValue;
    }
    if (T == CallableValue) {
      return this is CallableValue;
    }
    final ValueKind to = getKindFromType(T);
    if (kind == to) return true;
    return false;
  }

  bool get isTruthy;
  bool get isFalsey => !isTruthy;
  int get kHashCode;

  @override
  String toString() => 'Shadow${kind.code}Value: ${kToString()}';

  static final Map<Type, ValueKind> _typeKindMap = <Type, ValueKind>{
    BooleanValue: ValueKind.boolean,
    FunctionValue: ValueKind.function,
    ListValue: ValueKind.list,
    NativeFunctionValue: ValueKind.nativeFunction,
    NullValue: ValueKind.nullValue,
    NumberValue: ValueKind.number,
    ObjectValue: ValueKind.object,
    StringValue: ValueKind.string,
    ModuleValue: ValueKind.module,
    PrimitiveObjectValue: ValueKind.primitiveObject,
    ExceptionValue: ValueKind.exception,
    CallableValue: ValueKind.function,
  };

  static ValueKind getKindFromType(final Type type) => _typeKindMap[type]!;
}
