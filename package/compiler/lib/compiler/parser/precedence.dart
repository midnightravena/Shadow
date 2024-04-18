enum Precedence {
  none,
  assignment, // := = ? :
  or, // || ??
  and, // &&
  pipe, // |
  caret, // ^
  ampersand, // &
  equality, // == !=
  comparison, // > >= < <=
  sum, // + -
  factor, // * / // %
  exponent, // **
  unary, // ! ~ + -
  call, // () . [] ?.
  grouping, // (...)
  kekw,
}

extension PrecedenceUtils on Precedence {
  int get value => index;
  Precedence get nextPrecedence => Precedence.values[index + 1];
}
