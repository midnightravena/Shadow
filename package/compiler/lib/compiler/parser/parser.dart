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

  static void parseTryCatchStatement(final Compiler compiler) {
    compiler.consume(Tokens.braceLeft);
    final int tryJump = compiler.emitJump(OpCodes.opBeginTry);
    parseBlockStatement(compiler);
    compiler.emitOpCode(OpCodes.opEndTry);
    final int catchJump = compiler.emitJump(OpCodes.opJump);
    compiler.patchAbsoluteJump(tryJump);
    compiler.consume(Tokens.catchKw);
    compiler.consume(Tokens.parenLeft);
    compiler.consume(Tokens.identifier);
    final int index = parseIdentifierConstant(compiler);
    compiler.consume(Tokens.parenRight);
    compiler.emitOpCode(OpCodes.opBeginScope);
    compiler.emitOpCode(OpCodes.opDeclare);
    compiler.emitCode(index);
    compiler.consume(Tokens.braceLeft);
    parseBlockStatement(compiler);
    compiler.emitOpCode(OpCodes.opEndScope);
    compiler.patchJump(catchJump);
  }

  static Future<void> parseImportStatement(
    final Compiler compiler,
  ) async {
    if (compiler.scopeDepth != 0) {
      throw CompilationException.topLevelImports(
        compiler.moduleName,
        compiler.previousToken,
      );
    }
    compiler.consume(Tokens.string);
    final String modulePath =
        compiler.resolveImportPath(compiler.previousToken.literal as String);
    final String moduleName = compiler.resolveRelativePath(modulePath);
    int moduleIndex = -1;
    for (int i = 0; i < compiler.modules.length; i += 2) {
      final int x = compiler.modules[i];
      if (compiler.constants[x] == moduleName) {
        moduleIndex = i;
      }
    }
    if (moduleIndex == -1) {
      moduleIndex = compiler.modules.length;
      final int nameIndex = compiler.makeConstant(moduleName);
      final Compiler moduleCompiler = await compiler.createModuleCompiler(
        moduleIndex,
        modulePath,
        isAsync: false,
      );
      final int functionIndex =
          compiler.makeConstant(moduleCompiler.currentFunction);
      compiler.modules.add(nameIndex);
      compiler.modules.add(functionIndex);
      await moduleCompiler.compile();
    }
    if (compiler.match(Tokens.onlyKw)) {
      bool cont = true;
      while (cont && !compiler.check(Tokens.semi)) {
        compiler.emitOpCode(OpCodes.opImport);
        compiler.emitCode(moduleIndex);
        compiler.consume(Tokens.identifier);
        final int onlyIndex = parseIdentifierConstant(compiler);
        compiler.emitOpCode(OpCodes.opConstant);
        compiler.emitCode(onlyIndex);
        compiler.emitOpCode(OpCodes.opGetProperty);
        compiler.emitOpCode(OpCodes.opDeclare);
        compiler.emitCode(onlyIndex);
        cont = compiler.match(Tokens.comma);
      }
      compiler.consume(Tokens.semi);
    } else {
      compiler.emitOpCode(OpCodes.opImport);
      compiler.emitCode(moduleIndex);
      compiler.consume(Tokens.asKw);
      compiler.consume(Tokens.identifier);
      final int asIndex = parseIdentifierConstant(compiler);
      compiler.consume(Tokens.semi);
      compiler.emitOpCode(OpCodes.opDeclare);
      compiler.emitCode(asIndex);
    }
  }

  static void parseMatchableStatement(
    final Compiler compiler,
    final void Function() matcher,
  ) {
    final List<_MatchableCase> cases = <_MatchableCase>[];
    _MatchableCase? elseCase;
    final int startJump = compiler.emitJump(OpCodes.opAbsoluteJump);
    compiler.consume(Tokens.braceLeft);
    while (!compiler.match(Tokens.braceRight)) {
      final int start = compiler.currentAbsoluteOffset;
      if (compiler.match(Tokens.elseKw)) {
        if (elseCase != null) {
          throw CompilationException.duplicateElse(
            compiler.moduleName,
            compiler.previousToken,
          );
        }
        compiler.consume(Tokens.colon);
        parseStatement(compiler);
        final int exitJump = compiler.emitJump(OpCodes.opAbsoluteJump);
        elseCase = _MatchableCase(start, exitJump, -1);
      } else {
        matcher();
        compiler.consume(Tokens.colon);
        final int localJump = compiler.emitJump(OpCodes.opJumpIfFalse);
        parseStatement(compiler);
        compiler.emitOpCode(OpCodes.opPop);
        final int exitJump = compiler.emitJump(OpCodes.opAbsoluteJump);
        compiler.patchJump(localJump);
        compiler.emitOpCode(OpCodes.opPop);
        final int thenJump = compiler.emitJump(OpCodes.opAbsoluteJump);
        cases.add(_MatchableCase(start, thenJump, exitJump));
      }
    }
    final int end = compiler.currentAbsoluteOffset;
    for (int i = 0; i < cases.length; i++) {
      final _MatchableCase x = cases[i];
      compiler.patchAbsoluteJumpTo(
        x.thenJump,
        i + 1 < cases.length ? cases[i + 1].start : elseCase?.start ?? end,
      );
      compiler.patchAbsoluteJumpTo(x.elseJump, end);
    }
    if (elseCase != null) {
      compiler.patchAbsoluteJumpTo(elseCase.thenJump, end);
    }
    compiler.patchAbsoluteJumpTo(
      startJump,
      cases.isNotEmpty ? cases.first.start : elseCase?.start ?? end,
    );
  }

  static void parseWhenStatement(final Compiler compiler) {
    parseMatchableStatement(compiler, () {
      parseExpression(compiler);
    });
  }

  static void parseMatchStatement(final Compiler compiler) {
    compiler.consume(Tokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(Tokens.parenRight);
    parseMatchableStatement(compiler, () {
      compiler.emitOpCode(OpCodes.opTop);
      parseExpression(compiler);
      compiler.emitOpCode(OpCodes.opEqual);
    });
    compiler.emitOpCode(OpCodes.opPop);
  }
