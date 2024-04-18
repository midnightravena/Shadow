import '../token/exports.dart';

class CompilationException implements Exception {
  CompilationException(this.module, this.text);

  factory CompilationException.illegalToken(
    final String module,
    final Token token,
  ) =>
      CompilationException(
        module,
        <String>[
          'Illegal token "${token.type.code}" found at ${token.span}',
          if (token.error != null)
            '(${token.error}${token.errorSpan != null ? ' at ${token.errorSpan}' : ''})',
        ].join(' '),
      );
