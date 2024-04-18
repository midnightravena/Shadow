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
