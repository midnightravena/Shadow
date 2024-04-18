import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class IdentifierScanner {
  static const ScannerCustomRule rule =
      ScannerCustomRule(matches, readIdentifier);

  static const Set<Tokens> keywords = <Tokens>{
    Tokens.trueKw,
    Tokens.falseKw,
    Tokens.ifKw,
    Tokens.elseKw,
    Tokens.whileKw,
    Tokens.nullKw,
    Tokens.returnKw,
    Tokens.breakKw,
    Tokens.continueKw,
    Tokens.tryKw,
    Tokens.catchKw,
    Tokens.throwKw,
    Tokens.importKw,
    Tokens.asKw,
    Tokens.whenKw,
    Tokens.matchKw,
    Tokens.printKw,
    Tokens.forKw,
    Tokens.asyncKw,
    Tokens.awaitKw,
    Tokens.onlyKw,
  };

  static final Map<String, Tokens> keywordsMap = keywords.asNameMap().map(
        (final _, final Tokens x) => MapEntry<String, Tokens>(x.code, x),
      );

  static bool matches(
    final Scanner scanner,
    final InputIteration current,
  ) =>
      LexerUtils.isAlphaNumeric(current.char);

  static Token readIdentifier(
    final Scanner scanner,
    final InputIteration start,
  ) {
    final ShadowStringBuffer buffer = ShadowStringBuffer(start.char);
    InputIteration current = start;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!LexerUtils.isAlphaNumeric(current.char)) break;
      buffer.write(current.char);
      scanner.input.advance();
    }
    final String output = buffer.toString();
    return Token(
      keywordsMap[output] ?? Tokens.identifier,
      output,
      Span(start.point, current.point),
    );
  }
}
