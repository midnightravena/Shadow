import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'identifier.dart';
import 'number.dart';
import 'string.dart';

typedef ScannerRuleMatchFn = bool Function(
  Scanner scanner,
  InputIteration current,
);

typedef ScannerRuleReadFn = Token Function(
  Scanner scanner,
  InputIteration current,
);

class ScannerCustomRule {
  const ScannerCustomRule(this.matches, this.scan);

  final ScannerRuleMatchFn matches;
  final ScannerRuleReadFn scan;
}

class ScannerRules {
  static final Map<String, ScannerRuleReadFn> offset1ScanFns =
      Map<String, ScannerRuleReadFn>.fromEntries(
    <MapEntry<String, ScannerRuleReadFn>>[
      MapEntry<String, ScannerRuleReadFn>(
        Tokens.hash.code,
        scanComment,
      ),
      constructOffset1ScanFn(Tokens.parenLeft),
      constructOffset1ScanFn(Tokens.parenRight),
      constructOffset1ScanFn(Tokens.bracketLeft),
      constructOffset1ScanFn(Tokens.bracketRight),
      constructOffset1ScanFn(Tokens.braceLeft),
      constructOffset1ScanFn(Tokens.braceRight),
      constructOffset1ScanFn(Tokens.dot),
      constructOffset1ScanFn(Tokens.comma),
      constructOffset1ScanFn(Tokens.semi),
      constructOffset1ScanFn(Tokens.question),
      constructOffset1ScanFn(Tokens.colon),
      constructOffset1ScanFn(Tokens.plus),
      constructOffset1ScanFn(Tokens.minus),
      constructOffset1ScanFn(Tokens.asterisk),
      constructOffset1ScanFn(Tokens.slash),
      constructOffset1ScanFn(Tokens.modulo),
      constructOffset1ScanFn(Tokens.ampersand),
      constructOffset1ScanFn(Tokens.pipe),
      constructOffset1ScanFn(Tokens.caret),
      constructOffset1ScanFn(Tokens.tilde),
      constructOffset1ScanFn(Tokens.assign),
      constructOffset1ScanFn(Tokens.bang),
      constructOffset1ScanFn(Tokens.lesserThan),
      constructOffset1ScanFn(Tokens.greaterThan),
    ],
  );

  static final Map<String, ScannerRuleReadFn> offset2ScanFns =
      Map<String, ScannerRuleReadFn>.fromEntries(
    <MapEntry<String, ScannerRuleReadFn>>[
      constructOffset2ScanFn(Tokens.nullAccess),
      constructOffset2ScanFn(Tokens.nullOr),
      constructOffset2ScanFn(Tokens.declare),
      constructOffset2ScanFn(Tokens.exponent),
      constructOffset2ScanFn(Tokens.floor),
      constructOffset2ScanFn(Tokens.logicalAnd),
      constructOffset2ScanFn(Tokens.logicalOr),
      constructOffset2ScanFn(Tokens.equal),
      constructOffset2ScanFn(Tokens.notEqual),
      constructOffset2ScanFn(Tokens.lesserThanEqual),
      constructOffset2ScanFn(Tokens.greaterThanEqual),
      constructOffset2ScanFn(Tokens.rightArrow),
      constructOffset2ScanFn(Tokens.increment),
      constructOffset2ScanFn(Tokens.decrement),
      constructOffset2ScanFn(Tokens.plusEqual),
      constructOffset2ScanFn(Tokens.minusEqual),
      constructOffset2ScanFn(Tokens.asteriskEqual),
      constructOffset2ScanFn(Tokens.slashEqual),
      constructOffset2ScanFn(Tokens.moduloEqual),
      constructOffset2ScanFn(Tokens.ampersandEqual),
      constructOffset2ScanFn(Tokens.pipeEqual),
      constructOffset2ScanFn(Tokens.caretEqual),
    ],
  );

  static final Map<String, ScannerRuleReadFn> offset3ScanFns =
      Map<String, ScannerRuleReadFn>.fromEntries(
    <MapEntry<String, ScannerRuleReadFn>>[
      constructOffset3ScanFn(Tokens.exponentEqual),
      constructOffset3ScanFn(Tokens.floorEqual),
      constructOffset3ScanFn(Tokens.logicalAndEqual),
      constructOffset3ScanFn(Tokens.logicalOrEqual),
      constructOffset3ScanFn(Tokens.nullOrEqual),
    ],
  );

  static List<ScannerCustomRule> customScanFns = <ScannerCustomRule>[
    StringScanner.rule,
    NumberScanner.rule,
    IdentifierScanner.rule,
  ];

  static Token scan(
    final Scanner scanner,
    final InputIteration current,
  ) {
    if (current.char.isEmpty) {
      return scanEndOfFile(scanner, current);
    }

    final ScannerRuleReadFn scanFn = getOffset3ScanFn(scanner, current) ??
        getOffset2ScanFn(scanner, current) ??
        getOffset1ScanFn(scanner, current) ??
        getCustomScanFn(scanner, current) ??
        scanInvalidToken;

    return scanFn(scanner, current);
  }

  static ScannerRuleReadFn? getCustomScanFn(
    final Scanner scanner,
    final InputIteration current,
  ) {
    ScannerRuleReadFn? fn;
    for (final ScannerCustomRule x in customScanFns) {
      if (x.matches(scanner, current)) {
        fn = x.scan;
        break;
      }
    }
    return fn;
  }

  static ScannerRuleReadFn? getOffset1ScanFn(
    final Scanner scanner,
    final InputIteration current,
  ) =>
      offset1ScanFns[scanner.input.getCharactersAt(current.point.position, 1)];

  static ScannerRuleReadFn? getOffset2ScanFn(
    final Scanner scanner,
    final InputIteration current,
  ) =>
      offset2ScanFns[scanner.input.getCharactersAt(current.point.position, 2)];

  static ScannerRuleReadFn? getOffset3ScanFn(
    final Scanner scanner,
    final InputIteration current,
  ) =>
      offset3ScanFns[scanner.input.getCharactersAt(current.point.position, 3)];

  static MapEntry<String, ScannerRuleReadFn> constructOffset1ScanFn(
    final Tokens type,
  ) =>
      constructOffsetScanFn(type, 1);

  static MapEntry<String, ScannerRuleReadFn> constructOffset2ScanFn(
    final Tokens type,
  ) =>
      constructOffsetScanFn(type, 2);

  static MapEntry<String, ScannerRuleReadFn> constructOffset3ScanFn(
    final Tokens type,
  ) =>
      constructOffsetScanFn(type, 3);

  static MapEntry<String, ScannerRuleReadFn> constructOffsetScanFn(
    final Tokens type,
    final int offset,
  ) =>
      MapEntry<String, ScannerRuleReadFn>(
        type.code,
        (final Scanner scanner, final InputIteration current) {
          final ShadowStringBuffer buffer = ShadowStringBuffer(current.char);

          InputIteration end = current;
          for (int i = 0; i < offset - 1; i++) {
            end = scanner.input.advance();
            buffer.write(end.char);
          }

          return Token(
            type,
            buffer.toString(),
            Span(current.point, end.point),
          );
        },
      );

  static Token scanComment(
    final Scanner scanner,
    final InputIteration current,
  ) {
    while (!scanner.input.isEndOfLine()) {
      scanner.input.advance();
    }
    scanner.input.advance();
    return scanner.readToken();
  }

  static Token scanInvalidToken(
    final Scanner scanner,
    final InputIteration current,
  ) =>
      Token(
        Tokens.illegal,
        current.char,
        Span.fromSingleCursor(current.point),
      );

  static Token scanEndOfFile(
    final Scanner scanner,
    final InputIteration current,
  ) =>
      Token(
        Tokens.eof,
        current.char,
        Span.fromSingleCursor(current.point),
      );
}
