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

  static const Map<Tokens, Parserule> rules = <Tokens, Parserule>{
    Tokens.parenLeft: Parserule(
      prefix: Parser.parseGrouping,
      infix: Parser.parseCall,
      precedence: Precedence.grouping,
    ),
    Tokens.dot: Parserule(
      infix: Parser.parseDotCall,
      precedence: Precedence.call,
    ),
    Tokens.bracketLeft: Parserule(
      prefix: Parser.parseList,
      infix: Parser.parseBracketCall,
      precedence: Precedence.call,
    ),
    Tokens.braceLeft: Parserule(prefix: Parser.parseObject),
    Tokens.rightArrow: Parserule(prefix: Parser.parseFunction),
    Tokens.question: Parserule(
      infix: Parser.parseTernary,
      precedence: Precedence.assignment,
    ),
    Tokens.nullOr: Parserule(
      infix: Parser.parseNullOr,
      precedence: Precedence.or,
    ),
    Tokens.nullAccess: Parserule(
      infix: Parser.parseNullAccess,
      precedence: Precedence.call,
    ),
    Tokens.bang: Parserule(prefix: Parser.parseUnaryExpression),
    Tokens.tilde: Parserule(prefix: Parser.parseUnaryExpression),
    Tokens.equal: Parserule(
      precedence: Precedence.equality,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.notEqual: Parserule(
      precedence: Precedence.equality,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.lesserThan: Parserule(
      precedence: Precedence.comparison,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.lesserThanEqual: Parserule(
      precedence: Precedence.comparison,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.greaterThan: Parserule(
      precedence: Precedence.comparison,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.greaterThanEqual: Parserule(
      precedence: Precedence.comparison,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.plus: Parserule(
      precedence: Precedence.sum,
      prefix: Parser.parseUnaryExpression,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.minus: Parserule(
      precedence: Precedence.sum,
      prefix: Parser.parseUnaryExpression,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.asterisk: Parserule(
      precedence: Precedence.factor,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.slash: Parserule(
      precedence: Precedence.factor,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.floor: Parserule(
      precedence: Precedence.factor,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.modulo: Parserule(
      precedence: Precedence.factor,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.exponent: Parserule(
      precedence: Precedence.exponent,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.logicalAnd: Parserule(
      precedence: Precedence.and,
      infix: Parser.parseLogicalAnd,
    ),
    Tokens.logicalOr: Parserule(
      precedence: Precedence.or,
      infix: Parser.parseLogicalOr,
    ),
    Tokens.ampersand: Parserule(
      precedence: Precedence.ampersand,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.pipe: Parserule(
      precedence: Precedence.pipe,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.caret: Parserule(
      precedence: Precedence.caret,
      infix: Parser.parseBinaryExpression,
    ),
    Tokens.identifier: Parserule(prefix: Parser.parseIdentifier),
    Tokens.number: Parserule(prefix: Parser.parseNumber),
    Tokens.string: Parserule(prefix: Parser.parseString),
    Tokens.trueKw: Parserule(prefix: Parser.parseBoolean),
    Tokens.falseKw: Parserule(prefix: Parser.parseBoolean),
    Tokens.nullKw: Parserule(prefix: Parser.parseNull),
  };
