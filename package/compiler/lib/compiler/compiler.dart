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
