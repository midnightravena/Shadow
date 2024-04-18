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

  factory CompilationException.expectedXButReceivedX(
    final String module,
    final String expected,
    final String received,
    final String position,
  ) =>
      CompilationException(
        module,
        'Expected "$expected" but found "$received" at $position',
      );

  factory CompilationException.expectedXButReceivedToken(
    final String module,
    final String expected,
    final Tokens received,
    final BeizeSpan span,
  ) =>
      CompilationException.expectedXButReceivedX(
        module,
        expected,
        received.code,
        span.toString(),
      );

  factory CompilationException.expectedTokenButReceivedToken(
    final String module,
    final Tokens expected,
    final Tokens received,
    final BeizeSpan span,
  ) =>
      CompilationException.expectedXButReceivedX(
        module,
        expected.code,
        received.code,
        span.toString(),
      );

  factory CompilationException.cannotReturnInsideScript(
    final String module,
    final Token token,
  ) =>
      CompilationException(
        module,
        'Cannot return inside script ("${token.type.code}" found at ${token.span})',
      );

  factory CompilationException.cannotBreakContinueOutsideLoop(
    final String module,
    final Token token,
  ) =>
      CompilationException(
        module,
        'Cannot break or continue outside script ("${token.type.code}" found at ${token.span})',
      );

  factory CompilationException.topLevelImports(
    final String module,
    final Token token,
  ) =>
      CompilationException(
        module,
        'Only top-level imports are allowed ("${token.type.code}" found at ${token.span})',
      );

  factory CompilationException.duplicateElse(
    final String module,
    final Token token,
  ) =>
      CompilationException(
        module,
        'Multiple else classes are not allowed ("${token.type.code}" found at ${token.span})',
      );
