import '../vm/exports.dart';
import 'exports.dart';

class StringValue extends PrimitiveObjectValue {
  StringValue(this.value);

  final String value;

  @override
  Value get(final Value key) {
    if (key is StringValue) {
      switch (key.value) {
        case 'isEmpty':
          return NativeFunctionValue.sync(
            (final _) => BooleanValue(value.isEmpty),
          );

        case 'isNotEmpty':
          return NativeFunctionValue.sync(
            (final _) => BooleanValue(value.isNotEmpty),
          );

        case 'length':
          return NativeFunctionValue.sync(
            (final _) => NumberValue(value.length.toDouble()),
          );

        case 'compareTo':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue other = call.argumentAt(0);
              return NumberValue(
                value.compareTo(other.value).toDouble(),
              );
            },
          );

        case 'contains':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue other = call.argumentAt(0);
              return BooleanValue(value.contains(other.value));
            },
          );

        case 'startsWith':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue other = call.argumentAt(0);
              return BooleanValue(value.startsWith(other.value));
            },
          );

        case 'endsWith':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue other = call.argumentAt(0);
              return BooleanValue(value.endsWith(other.value));
            },
          );

        case 'indexOf':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue other = call.argumentAt(0);
              return NumberValue(
                value.indexOf(other.value).toDouble(),
              );
            },
          );

        case 'lastIndexOf':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue other = call.argumentAt(0);
              return NumberValue(
                value.lastIndexOf(other.value).toDouble(),
              );
            },
          );

        case 'substring':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final NumberValue start = call.argumentAt(0);
              final NumberValue end = call.argumentAt(1);
              return StringValue(
                value.substring(start.intValue, end.intValue),
              );
            },
          );

        case 'replaceFirst':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue from = call.argumentAt(0);
              final StringValue to = call.argumentAt(1);
              return StringValue(
                value.replaceFirst(from.value, to.value),
              );
            },
          );

        case 'replaceAll':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue from = call.argumentAt(0);
              final StringValue to = call.argumentAt(1);
              return StringValue(
                value.replaceAll(from.value, to.value),
              );
            },
          );

        case 'replaceFirstMapped':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue result = replaceMapped(call, 1);
              return result;
            },
          );

        case 'replaceAllMapped':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final StringValue result = replaceMapped(call);
              return result;
            },
          );

        case 'trim':
          return NativeFunctionValue.sync(
            (final _) => StringValue(value.trim()),
          );

        case 'trimLeft':
          return NativeFunctionValue.sync(
            (final _) => StringValue(value.trimLeft()),
          );

        case 'trimRight':
          return NativeFunctionValue.sync(
            (final _) => StringValue(value.trimRight()),
          );

        case 'padLeft':
          return NativeFunctionValue.sync((final NativeFunctionCall call) {
            final NumberValue amount = call.argumentAt(0);
            final StringValue by = call.argumentAt(1);
            return StringValue(value.padLeft(amount.intValue, by.value));
          });

        case 'padRight':
          return NativeFunctionValue.sync((final NativeFunctionCall call) {
            final NumberValue amount = call.argumentAt(0);
            final StringValue by = call.argumentAt(1);
            return StringValue(value.padRight(amount.intValue, by.value));
          });

        case 'split':
          return NativeFunctionValue.sync((final NativeFunctionCall call) {
            final StringValue delimiter = call.argumentAt(0);
            return ListValue(
              value
                  .split(delimiter.value)
                  .map((final String x) => StringValue(x))
                  .toList(),
            );
          });

        case 'codeUnitAt':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final NumberValue index = call.argumentAt(0);
              return NumberValue(
                value.codeUnitAt(index.intValue).toDouble(),
              );
            },
          );

        case 'charAt':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final NumberValue index = call.argumentAt(0);
              return StringValue(value[index.intValue]);
            },
          );

        case 'toCodeUnits':
          return NativeFunctionValue.sync(
            (final _) => ListValue(
              value.codeUnits
                  .map((final int x) => NumberValue(x.toDouble()))
                  .toList(),
            ),
          );

        case 'toLowerCase':
          return NativeFunctionValue.sync(
            (final _) => StringValue(value.toLowerCase()),
          );

        case 'toUpperCase':
          return NativeFunctionValue.sync(
            (final _) => StringValue(value.toUpperCase()),
          );

        case 'format':
          return NativeFunctionValue.sync(
            (final NativeFunctionCall call) {
              final PrimitiveObjectValue value = call.argumentAt(0);
              return StringValue(format(value));
            },
          );

        default:
      }
    }
    return super.get(key);
  }

  StringValue replaceMapped(
    final NativeFunctionCall call, [
    final int? count,
  ]) {
    final StringValue pattern = call.argumentAt(0);
    final CallableValue mapper = call.argumentAt(1);
    final String result = replacePatternMapped(
      pattern.value,
      (final Match match) {
        final Value result = call.frame.callValue(
          mapper,
          <Value>[StringValue(match.group(0)!)],
        ).unwrapUnsafe();
        return result.cast<StringValue>().value;
      },
      count: count,
    );
    return StringValue(result);
  }

  String replacePatternMapped(
    final Pattern pattern,
    final String Function(Match) mapper, {
    final int? count,
  }) {
    String result = value;
    int adjuster = 0;
    int i = 0;
    for (final Match x in pattern.allMatches(result)) {
      if (count != null && i >= count) break;
      final String by = mapper(x);
      final String nResult = result.replaceRange(
        x.start + adjuster,
        x.end + adjuster,
        by,
      );
      adjuster = nResult.length - result.length;
      result = nResult;
      i++;
    }
    return result;
  }

  String format(final PrimitiveObjectValue env) {
    if (env is ListValue) {
      int i = 0;
      return value.replaceAllMapped(
        RegExp(r'(?<!\\){([^}]*)}'),
        (final Match match) {
          final String key = match[1]!;
          if (key.isEmpty) {
            return env.getIndex(i++).kToString();
          }
          return env.getIndex(int.parse(key)).kToString();
        },
      );
    }
    final String result = value.replaceAllMapped(
      RegExp(r'(?<!\\){([^}]+)}'),
      (final Match match) {
        final String key = match[1]!;
        return env.get(StringValue(key)).kToString();
      },
    );
    return result;
  }

  @override
  final ValueKind kind = ValueKind.string;

  @override
  StringValue kClone() => StringValue(value);

  @override
  String kToString() => value;

  @override
  bool get isTruthy => value.isNotEmpty;

  @override
  int get kHashCode => value.hashCode;
}
