import '../bytecode.dart';
import '../values/exports.dart';
import 'native_exception.dart';

class RuntimeExpection extends NativeException {
  RuntimeExpection(super.message);

  factory RuntimeExpection.invalidLeftOperandType(
    final String expected,
    final String received,
  ) =>
      RuntimeExpection(
        'Invalid left operand value type (expected "$expected", received "$received")',
      );

  factory RuntimeExpection.invalidRightOperandType(
    final String expected,
    final String received,
  ) =>
      RuntimeExpection(
        'Invalid right operand value type (expected "$expected", received "$received")',
      );

  factory RuntimeExpection.undefinedVariable(final String name) =>
      RuntimeExpection('Undefined variable "$name"');

  factory RuntimeExpection.cannotRedecalreVariable(final String name) =>
      RuntimeExpection('Cannot redeclare variable "$name"');

  factory RuntimeExpection.unknownOpCode(final OpCodes opCode) =>
      RuntimeExpection('Unknown op code: ${opCode.name}');

  factory RuntimeExpection.unknownConstant(final dynamic constant) =>
      RuntimeExpection('Unknown constant: $constant');

  factory RuntimeExpection.cannotCastTo(
    final BeizeValueKind expected,
    final BeizeValueKind received,
  ) =>
      RuntimeExpection(
        'Cannot cast "${received.code}" to "${expected.code}"',
      );

  factory RuntimeExpection.unwrapFailed(final String message) =>
      RuntimeExpection('Unwrap failed due to "$message"');

  factory RuntimeExpection.cannotConvertDoubleToInteger(
    final double value,
  ) =>
      RuntimeExpection('Cannot convert "$value" to integer');

  factory RuntimeExpection.unexpectedArgumentType(
    final int index,
    final BeizeValueKind expected,
    final BeizeValueKind received,
  ) =>
      RuntimeExpection(
        'Expected argument at $index to be "${expected.code}", received "${received.code}"',
      );

  @override
  String toString() => 'RuntimeExpection: $message';
}
