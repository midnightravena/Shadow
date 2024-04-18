import 'span.dart';
import 'tokens.dart';
class Token {
  const Token(
    this.type,
    this.literal,
    this.span, {
    this.error,
    this.errorSpan,
  });

  final Tokens type;
  final dynamic literal;
  final Span span;

  final String? error;
  final Span? errorSpan;

  Token setLiteral(final dynamic literal) =>
      Token(type, literal, span, error: error, errorSpan: errorSpan);
}
