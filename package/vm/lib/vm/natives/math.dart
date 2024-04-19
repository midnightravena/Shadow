import 'dart:math';

import '../../values/exports.dart';
import '../namespace.dart';

abstract class MathNatives {
  static Random random = Random();

  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('random'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double value = random.nextDouble();
          return NumberValue(value);
        },
      ),
    );
    value.set(
      StringValue('pi'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) => NumberValue(pi),
      ),
    );
    value.set(
      StringValue('sin'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(sin(a));
        },
      ),
    );
    value.set(
      StringValue('cos'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(cos(a));
        },
      ),
    );
    value.set(
      StringValue('tan'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(tan(a));
        },
      ),
    );
    value.set(
      StringValue('asin'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(asin(a));
        },
      ),
    );
    value.set(
      StringValue('acos'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(acos(a));
        },
      ),
    );
    value.set(
      StringValue('atan'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(atan(a));
        },
      ),
    );
    value.set(
      StringValue('atan2'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          final double b = call.argumentAt<NumberValue>(1).value;
          return NumberValue(atan2(a, b));
        },
      ),
    );
    value.set(
      StringValue('exp'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(exp(a));
        },
      ),
    );
    value.set(
      StringValue('log'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(log(a));
        },
      ),
    );
    value.set(
      StringValue('min'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          final double b = call.argumentAt<NumberValue>(1).value;
          return NumberValue(min(a, b));
        },
      ),
    );
    value.set(
      StringValue('max'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          final double b = call.argumentAt<NumberValue>(1).value;
          return NumberValue(max(a, b));
        },
      ),
    );
    value.set(
      StringValue('pow'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          final double b = call.argumentAt<NumberValue>(1).value;
          return NumberValue(pow(a, b).toDouble());
        },
      ),
    );
    value.set(
      StringValue('sqrt'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final double a = call.argumentAt<NumberValue>(0).value;
          return NumberValue(sqrt(a));
        },
      ),
    );
    namespace.declare('Math', value);
  }
}
