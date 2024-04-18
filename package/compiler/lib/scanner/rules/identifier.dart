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
