enum Tokens {
  eof,
  illegal,
  identifier,
  string,
  number,
  hash, // #
  parenLeft, // (
  parenRight, // )
  bracketLeft, // [
  bracketRight, // ]
  braceLeft, // {
  braceRight, // }
  dot, // .
  comma, // ,
  semi, // ;
  question, // ?
  nullOr, // ??
  nullAccess, // ?.
  colon, // :
  declare, // :=
  assign, // =
  plus, // +
  minus, // -
  asterisk, // *
  exponent, // **
  slash, // /
  floor, // //
  modulo, // %
  ampersand, // &
  logicalAnd, // &&
  pipe, // |
  logicalOr, // ||
  caret, // ^
  tilde, // ~
  equal, // ==
  bang, // !
  notEqual, // !=
  lesserThan, // <
  greaterThan, // >
  lesserThanEqual, // <=
  greaterThanEqual, // >=
  rightArrow, // ->
  increment, // ++
  decrement, // --
  plusEqual, // +=
  minusEqual, // -=
  asteriskEqual, // *=
  exponentEqual, // **=
  slashEqual, // /=
  floorEqual, // //=
  moduloEqual, // %=
  ampersandEqual, // &=
  logicalAndEqual, // &&=
  pipeEqual, // |=
  logicalOrEqual, // ||=
  caretEqual, // ^=
  nullOrEqual, // ??=
  trueKw, // true
  falseKw, // false
  nullKw, // null
  ifKw, // if
  elseKw, // else
  whileKw, // while
  returnKw, // return
  breakKw, // break
  continueKw, // continue
  tryKw, // try
  catchKw, // catch
  throwKw, // throw
  importKw, // import
  asKw, // as
  whenKw, // when
  matchKw, // match
  printKw, // print
  forKw, // for
  asyncKw, // async
  awaitKw, // await
  onlyKw, // only
}

const Map<Tokens, String> _tokensCodeMap = <Tokens, String>{
  Tokens.eof: 'eof',
  Tokens.illegal: 'illegal',
  Tokens.identifier: 'identifier',
  Tokens.string: 'string',
  Tokens.number: 'number',
  Tokens.hash: '#',
  Tokens.parenLeft: '(',
  Tokens.parenRight: ')',
  Tokens.bracketLeft: '[',
  Tokens.bracketRight: ']',
  Tokens.braceLeft: '{',
  Tokens.braceRight: '}',
  Tokens.dot: '.',
  Tokens.comma: ',',
  Tokens.semi: ';',
  Tokens.question: '?',
  Tokens.nullOr: '??',
  Tokens.nullAccess: '?.',
  Tokens.colon: ':',
  Tokens.declare: ':=',
  Tokens.assign: '=',
  Tokens.plus: '+',
  Tokens.minus: '-',
  Tokens.asterisk: '*',
  Tokens.exponent: '**',
  Tokens.slash: '/',
  Tokens.floor: '//',
  Tokens.modulo: '%',
  Tokens.ampersand: '&',
  Tokens.logicalAnd: '&&',
  Tokens.pipe: '|',
  Tokens.logicalOr: '||',
  Tokens.caret: '^',
  Tokens.tilde: '~',
  Tokens.equal: '==',
  Tokens.bang: '!',
  Tokens.notEqual: '!=',
  Tokens.lesserThan: '<',
  Tokens.greaterThan: '>',
  Tokens.lesserThanEqual: '<=',
  Tokens.greaterThanEqual: '>=',
  Tokens.rightArrow: '->',
  Tokens.increment: '++',
  Tokens.decrement: '--',
  Tokens.plusEqual: '+=',
  Tokens.minusEqual: '-=',
  Tokens.asteriskEqual: '*=',
  Tokens.exponentEqual: '**=',
  Tokens.slashEqual: '/=',
  Tokens.floorEqual: '//=',
  Tokens.moduloEqual: '%=',
  Tokens.ampersandEqual: '&=',
  Tokens.logicalAndEqual: '&&=',
  Tokens.pipeEqual: '|=',
  Tokens.logicalOrEqual: '||=',
  Tokens.caretEqual: '^=',
  Tokens.nullOrEqual: '??=',
  Tokens.trueKw: 'true',
  Tokens.falseKw: 'false',
  Tokens.ifKw: 'if',
  Tokens.elseKw: 'else',
  Tokens.whileKw: 'while',
  Tokens.nullKw: 'null',
  Tokens.returnKw: 'return',
  Tokens.breakKw: 'break',
  Tokens.continueKw: 'continue',
  Tokens.tryKw: 'try',
  Tokens.catchKw: 'catch',
  Tokens.throwKw: 'throw',
  Tokens.importKw: 'import',
  Tokens.asKw: 'as',
  Tokens.whenKw: 'when',
  Tokens.matchKw: 'match',
  Tokens.printKw: 'print',
  Tokens.forKw: 'for',
  Tokens.asyncKw: 'async',
  Tokens.awaitKw: 'await',
  Tokens.onlyKw: 'only',
};

extension OutreTokensUtils on Tokens {
  String get code => _tokensCodeMap[this]!;
}
