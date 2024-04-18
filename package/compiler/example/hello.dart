import 'package:compiler/compiler.dart';
import 'package:vm/vm.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final ProgramConstant program = await Compiler.compileProject(
    root: p.join(p.current, 'example/project'),
    entrypoint: 'hello.shadow',
    options: CompilerOptions(),
  );
  print(program.serialize());
  final ProgramConstant real = ProgramConstant.deserialize(program.serialize());
  Disassembler.disassembleProgram(real);
  final VM vm = VM(real, VMOptions());
  await vm.run();
}
