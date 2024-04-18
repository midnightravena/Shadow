import 'dart:io';
import 'package:compiler/compiler.dart';
import 'package:vm/vm.dart';
import 'package:path/path.dart' as p;

final String testsDir = p.join(Directory.current.path, 'tests');

Future<ProgramConstant> compileTestScript(
  final String dir,
  final String scriptName,
) async {
  final ProgramConstant program = await Compiler.compileProject(
    root: p.join(testsDir, dir),
    entrypoint: scriptName,
    options: CompilerOptions(),
  );
  return program;
}

Future<List<String>> executeTestScript(
  final ProgramConstant program,
) async {
  final VM vm = VM(program, VMOptions());
  final List<String> output = <String>[];
  final NativeFunctionValue out = NativeFunctionValue.sync(
    (final NativeFunctionCall call) {
      final ShadowStringValue value = call.argumentAt(0).cast();
      output.add(value.value);
      return NullValue.value;
    },
  );
  vm.globalNamespace.declare('out', out);
  await vm.run();
  return output;
}
