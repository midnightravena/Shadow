import 'package:shared/shared.dart';
import '../../errors/exports.dart';
import '../../token/exports.dart';
import '../compiler.dart';
import 'precedence.dart';
import 'rules.dart';

abstract class Parser {
  static Future<void> parseStatement(final Compiler compiler) async {
    if (compiler.match(Tokens.braceLeft)) {
      return parseBlockStatement(compiler);
    }
    if (compiler.match(Tokens.ifKw)) {
      return parseIfStatement(compiler);
    }
    if (compiler.match(Tokens.whileKw)) {
      return parseWhileStatement(compiler);
    }
    if (compiler.match(Tokens.breakKw)) {
      return parseBreakStatement(compiler);
    }
    if (compiler.match(Tokens.continueKw)) {
      return parseContinueStatement(compiler);
    }
    if (compiler.match(Tokens.returnKw)) {
      return parseReturnStatement(compiler);
    }
    if (compiler.match(Tokens.throwKw)) {
      return parseThrowStatement(compiler);
    }
    if (compiler.match(Tokens.tryKw)) {
      return parseTryCatchStatement(compiler);
    }
    if (compiler.match(Tokens.importKw)) {
      return parseImportStatement(compiler);
    }
    if (compiler.match(Tokens.whenKw)) {
      return parseWhenStatement(compiler);
    }
    if (compiler.match(Tokens.matchKw)) {
      return parseMatchStatement(compiler);
    }
    if (compiler.match(Tokens.printKw)) {
      return parsePrintStatement(compiler);
    }
    if (compiler.match(Tokens.forKw)) {
      return parseForStatement(compiler);
    }
    return parseExpressionStatement(compiler);
  }

  static void parsePrintStatement(final Compiler compiler) {
    compiler.consume(Tokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(Tokens.parenRight);
    compiler.consume(Tokens.semi);
    if (!compiler.options.disablePrint) {
      compiler.emitOpCode(OpCodes.opPrint);
    } else {
      compiler.emitOpCode(OpCodes.opPop);
    }
  }

  static void parseIfStatement(final Compiler compiler) {
    compiler.consume(Tokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(Tokens.parenRight);
    final int thenJump = compiler.emitJump(OpCodes.opJumpIfFalse);
    compiler.emitOpCode(OpCodes.opPop);
    parseStatement(compiler);
    final int elseJump = compiler.emitJump(OpCodes.opJump);
    compiler.patchJump(thenJump);
    compiler.emitOpCode(OpCodes.opPop);
    if (compiler.match(Tokens.elseKw)) {
      parseStatement(compiler);
    }
    compiler.patchJump(elseJump);
  }

  static void parseWhileStatement(final Compiler compiler) {
    final int start = compiler.currentAbsoluteOffset;
    compiler.consume(Tokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(Tokens.parenRight);
    compiler.beginLoop(start);
    compiler.emitOpCode(OpCodes.opPop);
    parseStatement(compiler);
    final int jump = compiler.emitJump(OpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(jump, start);
    compiler.endLoop();
  }

  static void parseForStatement(final Compiler compiler) {
    compiler.consume(Tokens.parenLeft);
    if (!compiler.check(Tokens.semi)) {
      parseExpression(compiler);
      compiler.emitOpCode(OpCodes.opPop);
    }
    compiler.consume(Tokens.semi);
    final int conditionOffset = compiler.currentAbsoluteOffset;
    if (!compiler.check(Tokens.semi)) {
      parseExpression(compiler);
    } else {
      compiler.emitOpCode(OpCodes.opTrue);
    }
    compiler.consume(Tokens.semi);
    final int updateJump = compiler.emitJump(OpCodes.opJump);
    final int updateOffset = compiler.currentAbsoluteOffset;
    if (!compiler.check(Tokens.parenRight)) {
      parseExpression(compiler);
      compiler.emitOpCode(OpCodes.opPop);
    }
    final int conditionJump = compiler.emitJump(OpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(conditionJump, conditionOffset);
    compiler.patchJump(updateJump);
    compiler.consume(Tokens.parenRight);
    compiler.beginLoop(updateOffset);
    compiler.emitOpCode(OpCodes.opPop);
    parseStatement(compiler);
    final int jump = compiler.emitJump(OpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(jump, updateOffset);
    compiler.endLoop();
  }

  static void parseBreakStatement(final Compiler compiler) {
    if (compiler.loops.isEmpty) {
      throw CompilationException.cannotBreakContinueOutsideLoop(
        compiler.moduleName,
        compiler.previousToken,
      );
    }
    compiler.consume(Tokens.semi);
    compiler.emitBreak();
  }

  static void parseContinueStatement(final Compiler compiler) {
    if (compiler.loops.isEmpty) {
      throw CompilationException.cannotBreakContinueOutsideLoop(
        compiler.moduleName,
        compiler.previousToken,
      );
    }
    compiler.consume(Tokens.semi);
    compiler.emitContinue();
  }

  static void parseBlockStatement(final Compiler compiler) {
    compiler.emitOpCode(OpCodes.opBeginScope);
    while (!compiler.isEndOfFile() && !compiler.check(Tokens.braceRight)) {
      parseStatement(compiler);
    }
    compiler.emitOpCode(OpCodes.opEndScope);
    compiler.consume(Tokens.braceRight);
  }


  static void parseReturnStatement(final Compiler compiler) {
    if (compiler.mode != CompilerMode.function) {
      throw CompilationException.cannotReturnInsideScript(
        compiler.moduleName,
        compiler.previousToken,
      );
    }
    if (!compiler.check(Tokens.semi)) {
      parseExpression(compiler);
    } else {
      compiler.emitOpCode(OpCodes.opNull);
    }
    compiler.consume(Tokens.semi);
    compiler.emitOpCode(OpCodes.opReturn);
  }

  static void parseThrowStatement(final Compiler compiler) {
    parseExpression(compiler);
    compiler.consume(Tokens.semi);
    compiler.emitOpCode(OpCodes.opThrow);
  }
