import 'dart:io';
import 'package:path/path.dart' as p;
import '../bytecode.dart';
import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../scanner/exports.dart';
import '../token/exports.dart';
import 'parser/exports.dart';
import 'state.dart';

enum CompilerMode {
  function,
  script,
}

class CompilerOptions {
  CompilerOptions({
    this.disablePrint = false,
  });

  final bool disablePrint;
}

class Compiler {
  Compiler._(
    this.scanner, {
    required this.mode,
    required this.root,
    required this.modulePath,
    required this.moduleIndex,
    required this.modules,
    required this.constants,
    required this.options,
    this.parent,
  });

  final Compiler? parent;
  final CompilerOptions options;
  final Scanner scanner;
  final CompilerMode mode;
  final String root;
  final String modulePath;
  final int moduleIndex;
  final List<int> modules;
  final List<Constant> constants;

  late Token previousToken;
  late Token currentToken;
  late FunctionConstant currentFunction;

  late int scopeDepth;
  late final List<CompilerLoopState> loops;

  void prepare({
    required final bool isAsync,
  }) {
    currentFunction = FunctionConstant(
      moduleIndex: moduleIndex,
      isAsync: isAsync,
      arguments: <int>[],
      chunk: Chunk.empty(),
    );
    scopeDepth = 0;
    loops = <CompilerLoopState>[];
    if (parent != null) {
      copyTokenState(parent!);
    } else {
      currentToken = scanner.readToken();
    }
  }

  Compiler createFunctionCompiler({
    required final bool isAsync,
  }) {
    final Compiler derived = Compiler._(
      scanner,
      mode: CompilerMode.function,
      root: root,
      modulePath: modulePath,
      moduleIndex: moduleIndex,
      modules: modules,
      constants: constants,
      parent: this,
      options: options,
    );
    derived.prepare(isAsync: isAsync);
    return derived;
  }

  Future<Compiler> createModuleCompiler(
    final int moduleIndex,
    final String path, {
    required final bool isAsync,
  }) async {
    final File file = File(path);
    final Input input = await Input.fromFile(file);
    final Compiler derived = Compiler._(
      Scanner(input),
      mode: CompilerMode.script,
      root: root,
      modulePath: path,
      moduleIndex: moduleIndex,
      modules: modules,
      constants: constants,
      options: options,
    );
    derived.prepare(isAsync: isAsync);
    return derived;
  }

  String resolveImportPath(final String path) {
    final String importDir = p.dirname(modulePath);
    final String absolutePath = p.join(importDir, path);
    return p.normalize(absolutePath);
  }

  String resolveRelativePath(final String path) {
    final String relativePath = p.relative(path, from: root);
    return relativePath;
  }

  Future<FunctionConstant> compile() async {
    while (!isEndOfFile()) {
      await Parser.parseStatement(this);
    }
    return currentFunction;
  }

  Token advance() {
    previousToken = currentToken;
    currentToken = scanner.readToken();
    if (currentToken.type == Tokens.illegal) {
      throw CompilationException.illegalToken(
        moduleName,
        currentToken,
      );
    }
    return currentToken;
  }

  bool check(final Tokens type) => currentToken.type == type;

  bool match(final Tokens type) {
    if (!check(type)) return false;
    advance();
    return true;
  }

  void ensure(final Tokens type) {
    if (!check(type)) {
      throw CompilationException.expectedTokenButReceivedToken(
        moduleName,
        type,
        currentToken.type,
        currentToken.span,
      );
    }
  }

  void consume(final Tokens type) {
    ensure(type);
    advance();
  }

  void emitCode(final int code) {
    currentChunk.addCode(code, previousToken.span.start.row + 1);
  }

  void emitOpCode(final OpCodes opCode) => emitCode(opCode.index);

  void emitConstant(final Constant value) {
    emitOpCode(OpCodes.opConstant);
    emitCode(makeConstant(value));
  }

  bool hasConstant(final Constant value) => constants.contains(value);

  int makeConstant(final Constant value) {
    final int existingIndex = constants.indexOf(value);
    if (existingIndex != -1) return existingIndex;
    constants.add(value);
    return constants.length - 1;
  }

  int emitJump(final OpCodes opCode) {
    emitOpCode(opCode);
    emitCode(-1);
    return currentChunk.length - 1;
  }

  void patchJump(final int offset) {
    final int jump = currentChunk.length - offset - 1;
    currentChunk.codes[offset] = jump;
  }

  void patchAbsoluteJump(final int offset) {
    final int jump = currentChunk.length;
    currentChunk.codes[offset] = jump;
  }

  void patchAbsoluteJumpTo(final int offset, final int to) {
    currentChunk.codes[offset] = to;
  }

  void beginLoop(final int start) {
    final int endJump = emitJump(OpCodes.opJumpIfFalse);
    final CompilerLoopState loop = CompilerLoopState(
      scopeDepth: scopeDepth,
      start: start,
      endJump: endJump,
    );
    loops.add(loop);
  }

  void endLoop() {
    final CompilerLoopState loop = loops.removeLast();
    patchJump(loop.endJump);
    emitOpCode(OpCodes.opPop);
    loop.exitJumps.forEach(patchJump);
  }

  void endLoopScope() {
    final int count = scopeDepth - loops.last.scopeDepth;
    for (int i = 0; i < count; i++) {
      emitOpCode(OpCodes.opEndScope);
    }
  }

  void emitBreak() {
    endLoopScope();
    final int offset = emitJump(OpCodes.opJump);
    loops.last.exitJumps.add(offset);
  }

  void emitContinue() {
    final int jump = emitJump(OpCodes.opAbsoluteJump);
    patchAbsoluteJumpTo(jump, loops.last.start);
  }

  void beginScope() {
    scopeDepth++;
  }

  void endScope() {
    scopeDepth--;
  }

  void copyTokenState(final Compiler compiler) {
    previousToken = compiler.previousToken;
    currentToken = compiler.currentToken;
  }

  bool isEndOfFile() => currentToken.type == Tokens.eof;

  String get moduleName => constants[moduleIndex] as String;

  Chunk get currentChunk => currentFunction.chunk;

  int get currentAbsoluteOffset => currentChunk.length;

  static Future<ProgramConstant> compileProject({
    required final String root,
    required final String entrypoint,
    required final CompilerOptions options,
  }) async {
    final String fullPath = p.join(root, entrypoint);
    final File file = File(fullPath);
    final Input input = await Input.fromFile(file);
    final Compiler compiler = Compiler._(
      Scanner(input),
      options: options,
      mode: CompilerMode.script,
      root: root,
      modulePath: fullPath,
      moduleIndex: 0,
      modules: <int>[],
      constants: <Constant>[],
    );
    compiler.prepare(isAsync: true);
    final int nameIndex =
        compiler.makeConstant(compiler.resolveRelativePath(fullPath));
    final int functionIndex = compiler.makeConstant(compiler.currentFunction);
    compiler.modules.add(nameIndex);
    compiler.modules.add(functionIndex);
    await compiler.compile();
    return ProgramConstant(
      modules: compiler.modules,
      constants: compiler.constants,
    );
  }
}
