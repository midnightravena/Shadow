import '../../values/exports.dart';
import '../namespace.dart';

abstract class DateTimeNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('fromMillisecondsSinceEpoch'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final NumberValue ms = call.argumentAt(0);
          return newDateTimeInst(
            DateTime.fromMillisecondsSinceEpoch(ms.intValue),
          );
        },
      ),
    );
    value.set(
      StringValue('parse'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue value = call.argumentAt(0);
          return newDateTimeInst(DateTime.parse(value.value));
        },
      ),
    );
    value.set(
      StringValue('now'),
      NativeFunctionValue.sync(
        (final _) => newDateTimeInst(DateTime.now()),
      ),
    );
    namespace.declare('DateTime', value);
  }

  static ObjectValue newDateTimeInst(final DateTime dateTime) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('day'),
      NumberValue(dateTime.day.toDouble()),
    );
    value.set(
      StringValue('weekday'),
      NumberValue(dateTime.weekday.toDouble()),
    );
    value.set(
      StringValue('month'),
      NumberValue(dateTime.month.toDouble()),
    );
    value.set(
      StringValue('year'),
      NumberValue(dateTime.year.toDouble()),
    );
    value.set(
      StringValue('hour'),
      NumberValue(dateTime.hour.toDouble()),
    );
    value.set(
      StringValue('minute'),
      NumberValue(dateTime.minute.toDouble()),
    );
    value.set(
      StringValue('second'),
      NumberValue(dateTime.second.toDouble()),
    );
    value.set(
      StringValue('millisecond'),
      NumberValue(dateTime.millisecond.toDouble()),
    );
    value.set(
      StringValue('millisecondsSinceEpoch'),
      NumberValue(dateTime.millisecondsSinceEpoch.toDouble()),
    );
    value.set(
      StringValue('timeZoneName'),
      StringValue(dateTime.timeZoneName),
    );
    value.set(
      StringValue('timeZoneOffset'),
      NumberValue(dateTime.timeZoneOffset.inMilliseconds.toDouble()),
    );
    value.set(
      StringValue('iso'),
      StringValue(dateTime.toIso8601String()),
    );
    return value;
  }
}
