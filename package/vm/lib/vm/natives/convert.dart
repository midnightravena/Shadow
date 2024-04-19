import 'dart:convert';
import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class ConvertNatives {
  static void bind(final Namespace namespace) {
    final ObjectValue value = ObjectValue();
    value.set(
      StringValue('newBytesList'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final Value value = call.argumentAt(0);
          if (value is NullValue) {
            return newBytesList(<int>[]);
          }
          final ListValue bytes = value.cast();
          return newBytesList(
            bytes.elements
                .map(
                  (final Value x) => x.cast<NumberValue>().intValue,
                )
                .toList(),
          );
        },
      ),
    );
    value.set(
      StringValue('encodeAscii'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          return newBytesList(ascii.encode(input.value));
        },
      ),
    );
    value.set(
      StringValue('decodeAscii'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final ObjectValue input = call.argumentAt(0);
          return StringValue(ascii.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      StringValue('encodeBase64'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final ObjectValue input = call.argumentAt(0);
          return StringValue(base64Encode(toBytes(input)));
        },
      ),
    );
    value.set(
      StringValue('decodeBase64'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          return newBytesList(base64Decode(input.value));
        },
      ),
    );
    value.set(
      StringValue('encodeLatin1'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          return newBytesList(latin1.encode(input.value));
        },
      ),
    );
    value.set(
      StringValue('decodeLatin1'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final ObjectValue input = call.argumentAt(0);
          return StringValue(latin1.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      StringValue('encodeUtf8'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          return newBytesList(utf8.encode(input.value));
        },
      ),
    );
    value.set(
      StringValue('decodeUtf8'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final ObjectValue input = call.argumentAt(0);
          return StringValue(utf8.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      StringValue('encodeJson'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final Value input = call.argumentAt(0);
          return StringValue(jsonEncode(toJson(input)));
        },
      ),
    );
    value.set(
      StringValue('decodeJson'),
      NativeFunctionValue.sync(
        (final NativeFunctionCall call) {
          final StringValue input = call.argumentAt(0);
          return fromJson(jsonDecode(input.value));
        },
      ),
    );
    namespace.declare('Convert', value);
  }

  static List<int> toBytes(final ObjectValue bytesList) {
    if (bytesList.internals.containsKey('bytes')) {
      return bytesList.internals['bytes'] as List<int>;
    }
    throw NativeException('Object is not a bytes list');
  }

  static Value newBytesList(final List<int> bytes) {
    final ObjectValue bytesList = ObjectValue();
    bytesList.internals['bytes'] = bytes;
    bytesList.set(
      StringValue('bytes'),
      NativeFunctionValue.sync(
        (final _) => ListValue(
          bytes.map((final int x) => NumberValue(x.toDouble())).toList(),
        ),
      ),
    );
    return bytesList;
  }

  static Value fromJson(final Object? json) {
    if (json is bool) return BooleanValue(json);
    if (json == null) return NullValue.value;
    if (json is int) return NumberValue(json.toDouble());
    if (json is double) return NumberValue(json);
    if (json is String) return StringValue(json);
    if (json is List<dynamic>) {
      final ListValue list = ListValue();
      for (final Object? x in json) {
        list.push(fromJson(x));
      }
      return list;
    }
    if (json is Map<dynamic, dynamic>) {
      final ObjectValue obj = ObjectValue();
      for (final MapEntry<Object?, Object?> x in json.entries) {
        final Value key = fromJson(x.key);
        final Value value = fromJson(x.value);
        obj.set(key, value);
      }
      return obj;
    }
    return StringValue(json.toString());
  }

  static Object? toJson(final Value value) {
    switch (value.kind) {
      case ValueKind.boolean:
        return value.cast<BooleanValue>().value;

      case ValueKind.list:
        return value.cast<ListValue>().elements.map(toJson).toList();

      case ValueKind.nullValue:
        return null;

      case ValueKind.number:
        return value.cast<NumberValue>().numValue;

      case ValueKind.object:
        final ObjectValue obj = value.cast();
        final Map<Object?, Object?> json = <Object?, Object?>{};
        for (final MapEntry<Value, Value> x in obj.entries()) {
          final Object? key = toJson(x.key);
          final Object? value = toJson(x.value);
          json[key] = value;
        }
        return json;

      case ValueKind.string:
        return value.cast<StringValue>().value;

      default:
        return value.kToString();
    }
  }
}
