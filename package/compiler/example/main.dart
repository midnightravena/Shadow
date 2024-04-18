import 'package:compiler/compiler.dart';
import 'package:vm/vm.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final ProgramConstant program = await Compiler.compileProject(
    root: p.join(p.current, 'example/project'),
    entrypoint: 'main.shadow',
    options: CompilerOptions(),
  );
  final SerializedConstant serialized = program.serialize();
  print(serialized);
  final ProgramConstant real = ProgramConstant.deserialize(serialized);
  Disassembler.disassembleProgram(real);
  final VM vm = VM(real, VMOptions());
  await vm.run();
}
