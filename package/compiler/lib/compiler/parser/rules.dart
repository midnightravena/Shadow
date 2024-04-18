import '../../token/exports.dart';
import '../compiler.dart';
import 'parser.dart';
import 'precedence.dart';

typedef ParseruleFn = void Function(Compiler compiler);

class Parserule {
  const Parserule({
    this.precedence = Precedence.none,
    this.prefix,
    this.infix,
  });

  final Precedence precedence;
  final ParseruleFn? prefix;
  final ParseruleFn? infix;

  static const Parserule none = Parserule();
