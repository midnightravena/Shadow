import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class StringScanner {
  static const ScannerCustomRule rule = ScannerCustomRule(matches, readString);

  static const String rawStringIdentifier = 'r';

  static bool isRawStringIdentifier(final String char) =>
      char == rawStringIdentifier;

  static bool matches(
    final Scanner scanner,
    final InputIteration current,
  ) =>
      LexerUtils.isQuote(current.char) ||
      (isRawStringIdentifier(current.char) &&
          LexerUtils.isQuote(scanner.input.peek().char));

  static Token readString(
    final Scanner scanner,
    final InputIteration current,
  ) {
    final Cursor start = current.point;
    final bool isRaw = isRawStringIdentifier(current.char);
    if (isRaw) {
      final String delimiter = scanner.input.advance().char;
      return readRawString(scanner, delimiter, start);
    }

    return processString(readRawString(scanner, current.char, start));
  }

  static Token processString(final Token token) {
    final String literal = token.literal as String;
    final int length = literal.length;
    final ShadowStringBuffer buffer = ShadowStringBuffer();

    bool escaped = false;
    int i = 0;
    int row = 0;
    int column = 0;
    while (i < length) {
      final String char = literal[i];
      i++;
      column++;

      if (!escaped && char == r'\') {
        escaped = true;
        continue;
      }

      if (!escaped) {
        buffer.write(char);
        continue;
      }

      switch (char) {
        case r'\':
          buffer.write(r'\');

        case 't':
          buffer.write('\t');

        case 'r':
          buffer.write('\r');

        case 'n':
          buffer.write('\n');

        case 'f':
          buffer.write('\f');

        case 'b':
          buffer.write('\b');

        case 'v':
          buffer.write('\v');

        case 'u':
          final int end = i + 4;
          if (end < length) {
            final String digit = literal.substring(i, end);
            final int? parsed = int.tryParse(digit, radix: 16);
            if (parsed != null) {
              buffer.write(String.fromCharCode(parsed));
              i = end;
              break;
            }
          }

          return Token(
            Tokens.illegal,
            literal,
            token.span,
            error: 'Invalid unicode escape sequence',
            errorSpan: Span(
              Cursor(
                position: token.span.start.position + i,
                row: row,
                column: column,
              ),
              Cursor(
                position: token.span.start.position + end,
                row: row,
                column: column + 4,
              ),
            ),
          );

        case 'x':
          final int end = i + 2;
          if (end < length) {
            final String digit = literal.substring(i, end);
            final int? parsed = int.tryParse(digit, radix: 16);
            if (parsed != null) {
              buffer.write(String.fromCharCode(parsed));
              i = end;
              break;
            }
          }

          return Token(
            Tokens.illegal,
            literal,
            token.span,
            error: 'Invalid unicode escape sequence',
            errorSpan: Span(
              Cursor(
                position: token.span.start.position + i,
                row: row,
                column: column,
              ),
              Cursor(
                position: token.span.start.position + end,
                row: row,
                column: column + 2,
              ),
            ),
          );

        default:
          if (char == '\n') {
            row++;
            column = 0;
          }
          buffer.write(char);
      }
      escaped = false;
    }

    return Token(token.type, buffer.toString(), token.span);
  }

  static Token readRawString(
    final Scanner scanner,
    final String delimiter,
    final Cursor start,
  ) {
    final ShadowStringBuffer buffer = ShadowStringBuffer();

    bool finished = false;
    bool escaped = false;
    Cursor end = start;

    while (!finished && !scanner.input.isEndOfFile()) {
      final InputIteration current = scanner.input.advance();
      if (!escaped && current.char == delimiter) {
        finished = true;
        break;
      }
      escaped = !escaped && current.char == r'\';
      buffer.write(current.char);
      end = current.point;
    }

    final String output = buffer.toString();
    if (!finished) {
      return Token(
        Tokens.illegal,
        output,
        Span(start, end),
        error: 'Unterminated string literal',
      );
    }

    return Token(Tokens.string, output, Span(start, end));
  }
}
