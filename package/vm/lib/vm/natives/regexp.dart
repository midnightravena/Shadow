import '../../values/exports.dart';
import '../exports.dart';

abstract class RegExpNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('new'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue value = call.argumentAt(0);
          final Value flags = call.argumentAt(1);
          return newRegExp(
            value.value,
            flags is NullValue ? '' : flags.cast<StringValue>().value,
          );
        },
      ),
    );
    namespace.declare('RegExp', value);
  }

  static Value newRegExp(final String patternValue, final String flags) {
    final RegExp regex = RegExp(
      patternValue,
      caseSensitive: !flags.contains('i'),
      dotAll: flags.contains('s'),
      multiLine: flags.contains('m'),
      unicode: flags.contains('u'),
    );
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('isCaseInsensitive'),
      BooleanValue(!regex.isCaseSensitive),
    );
    value.set(
      StringValue('isDotAll'),
      BooleanValue(regex.isDotAll),
    );
    value.set(
      StringValue('isMultiLine'),
      BooleanValue(regex.isMultiLine),
    );
    value.set(
      StringValue('isUnicode'),
      BooleanValue(regex.isUnicode),
    );
    value.set(
      StringValue('pattern'),
      StringValue(regex.pattern),
    );
    value.set(
      StringValue('hasMatch'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          return BooleanValue(regex.hasMatch(input.value));
        },
      ),
    );
    value.set(
      StringValue('stringMatch'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          final String? match = regex.stringMatch(input.value);
          return match is String ? StringValue(match) : NullValue.value;
        },
      ),
    );
    value.set(
      StringValue('firstMatch'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          final RegExpMatch? match = regex.firstMatch(input.value);
          return match is RegExpMatch ? newRegExpMatch(match) : NullValue.value;
        },
      ),
    );
    value.set(
      StringValue('allMatches'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          final Iterable<RegExpMatch> matches = regex.allMatches(input.value);
          return ListValue(matches.map(newRegExpMatch).toList());
        },
      ),
    );
    value.set(
      StringValue('replaceFirst'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          final StringValue to = call.argumentAt(1);
          return StringValue(
            input.value.replaceFirst(regex, to.value),
          );
        },
      ),
    );
    value.set(
      StringValue('replaceAll'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          final StringValue to = call.argumentAt(1);
          return StringValue(
            input.value.replaceAll(regex, to.value),
          );
        },
      ),
    );
    value.set(
      StringValue('replaceFirstMapped'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue result = replaceMapped(regex, call, 1);
          return result;
        },
      ),
    );
    value.set(
      StringValue('replaceAllMapped'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue result = replaceMapped(regex, call);
          return result;
        },
      ),
    );
    return value;
  }

  static Value newRegExpMatch(final RegExpMatch match) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('input'),
      StringValue(match.input),
    );
    value.set(
      StringValue('groupCount'),
      NumberValue(match.groupCount.toDouble()),
    );
    value.set(
      StringValue('groupNames'),
      ListValue(
        match.groupNames.map((final String x) => StringValue(x)).toList(),
      ),
    );
    value.set(
      StringValue('namedGroup'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          final String? result = match.namedGroup(input.value);
          return result is String ? StringValue(result) : NullValue.value;
        },
      ),
    );
    value.set(
      StringValue('group'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final NumberValue input = call.argumentAt(0);
          final String? result = match.group(input.intValue);
          return result is String ? StringValue(result) : NullValue.value;
        },
      ),
    );
    return value;
  }

  static StringValue replaceMapped(
    final RegExp regex,
    final NativeFunctionCall call, [
    final int? count,
  ]) {
    final StringValue input = call.argumentAt(0);
    final CallableValue mapper = call.argumentAt(1);
    final String result = input.replacePatternMapped(
      regex,
      (final Match match) {
        final Value result = call.frame.callValue(
          mapper,
          <Value>[newRegExpMatch(match as RegExpMatch)],
        ).unwrapUnsafe();
        return result.cast<StringValue>().value;
      },
      count: count,
    );
    return StringValue(result);
  }
}
