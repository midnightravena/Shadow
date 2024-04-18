import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class NumberScanner {
  static const ScannerCustomRule rule = ScannerCustomRule(matches, readNumber);

  static bool matches(
    final Scanner scanner,
    final InputIteration current,
  ) =>
      LexerUtils.isNumeric(current.char);

  static Token readNumber(
    final Scanner scanner,
    final InputIteration start,
  ) {
    final ShadowStringBuffer buffer = ShadowStringBuffer(start.char);

    InputIteration current = start;
    bool hasDot = false;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!LexerUtils.isNumericContent(current.char)) break;
      if (current.char == '.') {
        if (hasDot) break;
        hasDot = true;
      }
      buffer.write(current.char);
      scanner.input.advance();
    }
