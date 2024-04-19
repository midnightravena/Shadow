import '../bytecode.dart';
import '../values/exports.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'result.dart';
import 'try_frame.dart';
import 'vm.dart';

class CallFrame {
  CallFrame({
    required this.vm,
    required this.function,
    required this.namespace,
    this.parent,
  });

  int ip = 0;
  int sip = 0;
  int scopeDepth = 0;
  final List<TryFrame> tryFrames = <TryFrame>[];

  final VM vm;
  final CallFrame? parent;
  final FunctionConstant function;
  final Namespace namespace;

  InterpreterResult callValue(
    final Value value,
    final List<Value> arguments,
  ) {
    if (value is FunctionValue) {
      if (value.isAsync) {
        return callAsyncFunctionValue(arguments, value);
      } else {
        return callFunctionValue(arguments, value);
      }
    }
    if (value is NativeFunctionValue) {
      return callNativeFunction(value, arguments);
    }
    return InterpreterResult.fail(
      ExceptionValue(
        'ShadowRuntimeException: Value "${value.kind.code}" is not callable',
        getStackTrace(),
      ),
    );
  }

  InterpreterResult callNativeFunction(
    final NativeFunctionValue function,
    final List<Value> arguments,
  ) {
    final NativeFunctionCall call = NativeFunctionCall(
      frame: this,
      arguments: arguments,
    );
    final InterpreterResult result = function.execute(call);
    return result;
  }

  CallFrame prepareCallFunctionValue(
    final List<Value> arguments,
    final FunctionValue function,
  ) {
    final Namespace namespace = function.namespace.enclosed;
    int i = 0;
    for (final int argIndex in function.constant.arguments) {
      final String argName = vm.program.constantAt(argIndex) as String;
      final Value value = i < arguments.length ? arguments[i] : NullValue.value;
      namespace.declare(argName, value);
      i++;
    }
    final CallFrame frame = CallFrame(
      vm: vm,
      parent: this,
      function: function.constant,
      namespace: namespace,
    );
    return frame;
  }

  InterpreterResult callFunctionValue(
    final List<Value> arguments,
    final FunctionValue function,
  ) {
    final CallFrame frame = prepareCallFunctionValue(arguments, function);
    final InterpreterResult result = Interpreter(frame).run();
    return result;
  }

  InterpreterResult callAsyncFunctionValue(
    final List<Value> arguments,
    final FunctionValue function,
  ) {
    final UnawaitedValue value = UnawaitedValue(
      arguments,
      (final NativeFunctionCall call) async {
        final CallFrame frame =
            prepareCallFunctionValue(call.arguments, function);
        final InterpreterResult result = await Interpreter(frame).runAsync();
        return result;
      },
    );
    return InterpreterResult.success(value);
  }

  Constant readConstantAt(final int index) =>
      vm.program.constantAt(function.chunk.codeAt(index));

  String toStackTraceLine(final int depth) {
    final String moduleName = vm.program.moduleNameAt(function.moduleIndex);
    final int line = function.chunk.lineAt(sip);
    return '#$depth   $moduleName at line $line';
  }

  String getStackTrace([final int depth = 0]) {
    final String current = toStackTraceLine(depth);
    if (parent == null) return current;
    return '$current\n${parent!.getStackTrace(depth + 1)}';
  }
}
