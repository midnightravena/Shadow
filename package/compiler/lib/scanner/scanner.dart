import '../lexer/exports.dart';
import '../token/exports.dart';
import 'rules/exports.dart';

class Scanner {
  Scanner(this.input);

  final Input input;

  Token readToken() {
    input.skipWhitespace();
    final InputIteration current = input.advance();
    return ScannerRules.scan(this, current);
  }
}
