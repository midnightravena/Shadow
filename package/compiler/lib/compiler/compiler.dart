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
