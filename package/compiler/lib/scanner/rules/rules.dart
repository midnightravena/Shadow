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
