import '../vm/exports.dart';
import 'exports.dart';

class ListValue extends PrimitiveObjectValue {
  ListValue([final List<Value>? elements]) : elements = elements ?? <Value>[];

  final List<Value> elements;

  @override
  Value get(final Value key) {
    if (key is StringValue) {
      switch (key.value) {
        case 'push':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              push(call.argumentAt(0));
              return NullValue.value;
            },
          );

        case 'pushAll':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              pushAll(call.argumentAt(0));
              return NullValue.value;
            },
          );

        case 'pop':
          return NativeFunctionValue.sync((final _) => pop());

        case 'clear':
          return NativeFunctionValue.sync(
            (final _) {
              elements.clear();
              return NullValue.value;
            },
          );

        case 'length':
          return NativeFunctionValue.sync(
            (final _) => NumberValue(length.toDouble()),
          );

        case 'isEmpty':
          return NativeFunctionValue.sync(
            (final _) => BooleanValue(elements.isEmpty),
          );

        case 'isNotEmpty':
          return NativeFunctionValue.sync(
            (final _) => BooleanValue(elements.isNotEmpty),
          );

        case 'clone':
          return NativeFunctionValue.sync((final _) => kClone());

        case 'reversed':
          return NativeFunctionValue.sync(
            (final _) => ListValue(elements.reversed.toList()),
          );

        case 'contains':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final Value value = call.argumentAt(0);
              return BooleanValue(
                elements.any((final Value x) => value.kEquals(x)),
              );
            },
          );

        case 'indexOf':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final Value value = call.argumentAt(0);
              return NumberValue(
                elements
                    .indexWhere((final Value x) => value.kEquals(x))
                    .toDouble(),
              );
            },
          );

        case 'lastIndexOf':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final Value value = call.argumentAt(0);
              return NumberValue(
                elements
                    .lastIndexWhere((final Value x) => value.kEquals(x))
                    .toDouble(),
              );
            },
          );

        case 'remove':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final Value value = call.argumentAt(0);
              elements.removeWhere((final Value x) => value.kEquals(x));
              return NullValue.value;
            },
          );

        case 'sublist':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final NumberValue start = call.argumentAt(0);
              final NumberValue end = call.argumentAt(1);
              final int iEnd = end.intValue;
              final List<Value> sublist = elements.sublist(
                start.intValue,
                iEnd < length ? iEnd : length,
              );
              return ListValue(sublist);
            },
          );

        case 'find':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final CallableValue predicate = call.argumentAt(0);
              for (final Value x in elements) {
                final Value result =
                    call.frame.callValue(predicate, <Value>[x]).unwrapUnsafe();
                if (result.isTruthy) return x;
              }
              return NullValue.value;
            },
          );

        case 'findIndex':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final CallableValue predicate = call.argumentAt(0);
              for (int i = 0; i < elements.length; i++) {
                final Value x = elements[i];
                final Value result =
                    call.frame.callValue(predicate, <Value>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return NumberValue(i.toDouble());
                }
              }
              return NumberValue(-1);
            },
          );

        case 'findLastIndex':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final CallableValue predicate = call.argumentAt(0);
              for (int i = elements.length - 1; i >= 0; i--) {
                final Value x = elements[i];
                final Value result =
                    call.frame.callValue(predicate, <Value>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return NumberValue(i.toDouble());
                }
              }
              return NumberValue(-1);
            },
          );

        case 'filter':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final CallableValue predicate = call.argumentAt(0);
              final ListValue nValue = ListValue();
              for (final Value x in elements) {
                final Value result =
                    call.frame.callValue(predicate, <Value>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(x);
                }
              }
              return nValue;
            },
          );

        case 'map':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final CallableValue predicate = call.argumentAt(0);
              final ListValue nValue = ListValue();
              for (final Value x in elements) {
                final Value result =
                    call.frame.callValue(predicate, <Value>[x]).unwrapUnsafe();
                nValue.push(result);
              }
              return nValue;
            },
          );

        case 'where':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final CallableValue predicate = call.argumentAt(0);
              final ListValue nValue = ListValue();
              for (final Value x in elements) {
                final Value result =
                    call.frame.callValue(predicate, <Value>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(result);
                }
              }
              return nValue;
            },
          );

        case 'sort':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final CallableValue predicate = call.argumentAt(0);
              final List<Value> sorted = elements.toList();
              for (int i = 0; i < sorted.length; i++) {
                bool swapped = false;
                for (int j = 0; j < sorted.length - i - 1; j++) {
                  final Value a = sorted[j];
                  final Value b = sorted[j + 1];
                  final Value result = call.frame
                      .callValue(predicate, <Value>[a, b]).unwrapUnsafe();
                  final bool shouldSwap = result.cast<NumberValue>().value > 0;
                  if (shouldSwap) {
                    sorted[j] = b;
                    sorted[j + 1] = a;
                    swapped = true;
                  }
                }
                if (!swapped) break;
              }
              return ListValue(sorted);
            },
          );

        case 'flat':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final NumberValue level = call.argumentAt(0);
              return ListValue(flat(level.intValue));
            },
          );

        case 'flatDeep':
          return NativeFunctionValue.sync(
            (final _) => ListValue(flatDeep()),
          );

        case 'unique':
          return NativeFunctionValue.sync(
            (final _) {
              final ListValue unique = ListValue();
              final List<int> hashes = <int>[];
              for (final Value x in elements) {
                if (!hashes.contains(x.kHashCode)) {
                  unique.push(x);
                  hashes.add(x.kHashCode);
                }
              }
              return unique;
            },
          );

        case 'forEach':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final CallableValue predicate = call.argumentAt(0);
              for (final Value x in elements) {
                call.frame.callValue(predicate, <Value>[x]);
              }
              return NullValue.value;
            },
          );

        case 'join':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue delimiter = call.argumentAt(0);
              final String delimiterValue = delimiter.value;
              final StringBuffer buffer = StringBuffer();
              final int max = length;
              for (int i = 0; i < max; i++) {
                buffer.write(elements[i].kToString());
                if (i < max - 1) {
                  buffer.write(delimiterValue);
                }
              }
              return StringValue(buffer.toString());
            },
          );

        default:
      }
    }
    if (key is NumberValue) return getIndex(key.intValue);
    return super.get(key);
  }

  @override
  void set(final Value key, final Value value) {
    if (key is NumberValue) return setIndex(key.intValue, value);
    super.set(key, value);
  }

  Value getIndex(final int index) =>
      index < length ? elements[index] : NullValue.value;

  void setIndex(final int index, final Value value) {
    if (index > length) {
      elements.addAll(
        List<NullValue>.filled(
          index - length + 1,
          NullValue.value,
        ),
      );
    }
    elements[index] = value;
  }

  void push(final Value value) {
    elements.add(value);
  }

  void pushAll(final ListValue value) {
    elements.addAll(value.elements);
  }

  Value pop() {
    if (elements.isNotEmpty) {
      return elements.removeLast();
    }
    return NullValue.value;
  }

  List<Value> flat(final int level) {
    List<Value> flat = elements.toList();
    for (int i = 0; i < level; i++) {
      flat = _flatOnce(flat.cast<ListValue>());
    }
    return flat;
  }

  List<Value> flatDeep() {
    final List<Value> flat = <Value>[];
    for (final Value x in elements) {
      if (x is ListValue) {
        flat.addAll(x.flatDeep());
      } else {
        flat.add(x);
      }
    }
    return flat;
  }

  int get length => elements.length;

  @override
  final ValueKind kind = ValueKind.list;

  @override
  ListValue kClone() => ListValue(elements.toList());

  @override
  String kToString() =>
      '[${elements.map((final Value x) => x.kToString()).join(', ')}]';

  @override
  bool get isTruthy => elements.isNotEmpty;

  @override
  int get kHashCode => elements.hashCode;
}

List<Value> _flatOnce(final List<Value> elements) {
  final List<Value> flat = <Value>[];
  for (final Value x in elements) {
    flat.addAll(x.cast<ListValue>().elements);
  }
  return flat;
}
