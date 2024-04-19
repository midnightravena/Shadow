import 'dart:async';
import '../bytecode.dart';
import '../errors/exports.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'result.dart';

enum VMState {
  ready,
  running,
  finished,
}

typedef VMOnUncaughtException = void Function(ExceptionValue);
typedef VMOnPrint = void Function(String);

class VMOptions {
  VMOptions({
    this.disablePrint = false,
    this.printPrefix = 'print: ',
    this.onUnhandledException,
    this.onPrint,
  });

  final bool disablePrint;
  final String printPrefix;
  final VMOnUncaughtException? onUnhandledException;
  final VMOnPrint? onPrint;
}

class VM {
  VM(this.program, this.options);

  final ProgramConstant program;
  final VMOptions options;

  final Namespace globalNamespace = Namespace.withNatives();
  final Map<int, ModuleValue> modules = <int, ModuleValue>{};
  late final CallFrame topFrame;

  Future<void> run() async {
    final PreparedModule prepared = prepareModule(
      0,
      isEntrypoint: true,
    );
    final InterpreterResult result = await loadModuleAsync(prepared);
    if (result.isFailure) {
      onUnhandledException(result.error);
    }
  }

  ModuleValue? lookupModule(final int moduleIndex) => modules[moduleIndex];

  PreparedModule prepareModule(
    final int moduleIndex, {
    required final bool isEntrypoint,
  }) {
    final Namespace namespace = globalNamespace.enclosed;
    final ModuleValue value = ModuleValue(namespace);
    modules[moduleIndex] = value;
    final CallFrame frame = CallFrame(
      vm: this,
      function: program.moduleFunctionAt(moduleIndex),
      namespace: namespace,
      parent: !isEntrypoint ? topFrame : null,
    );
    if (isEntrypoint) {
      topFrame = frame;
    }
    return PreparedModule(
      moduleIndex: moduleIndex,
      frame: frame,
      value: value,
    );
  }

  InterpreterResult loadModule(final PreparedModule module) {
    final InterpreterResult result = Interpreter(module.frame).run();
    if (result.isFailure) return result;
    return InterpreterResult.success(module.value);
  }

  Future<InterpreterResult> loadModuleAsync(
    final PreparedModule module,
  ) async {
    final InterpreterResult result = await Interpreter(module.frame).runAsync();
    if (result.isFailure) return result;
    return InterpreterResult.success(module.value);
  }

  void onUnhandledException(final ExceptionValue err) {
    if (options.onUnhandledException != null) {
      options.onUnhandledException!.call(err);
      return;
    }
    throw UnhandledExpection(err.toCustomString(includePrefix: false));
  }
}

class PreparedModule {
  const PreparedModule({
    required this.moduleIndex,
    required this.frame,
    required this.value,
  });

  final int moduleIndex;
  final CallFrame frame;
  final ModuleValue value;
}
