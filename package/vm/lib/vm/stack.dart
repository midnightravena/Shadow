import '../values/exports.dart';

class Stack {
  final List<Value> values = <Value>[];

  void push(final Value value) => values.add(value);
  T pop<T extends Value>() => values.removeLast().cast<T>();
  T top<T extends Value>() => values.last.cast<T>();

  int get length => values.length;

  @override
  String toString() =>
      'ShadowStack [${values.map((final Value x) => x.kToString()).join(', ')}]';
}
