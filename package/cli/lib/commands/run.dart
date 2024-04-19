import 'package:args/command_runner.dart';
import 'package:compiler/compiler.dart';
import 'package:vm/vm.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import '../utils.dart';

class RunCommand extends Command<Future<void>> {
  RunCommand() {
    argParser.addFlag(
      disablePrintFlag,
      help: 'Disable native print function.',
      negatable: false,
    );
  }

  @override
  final String name = 'run';

  @override
  final List<String> aliases = <String>['execute'];

  @override
  final String description = 'Run a program.';

  @override
  String get invocation => '${runner!.executableName} $name <path/to/file>';

  @override
  Future<void> run() async {
    final String? entrypointRaw = argResults!.rest.firstOrNull;
    final bool disablePrint = argResults![disablePrintFlag] as bool;
    if (entrypointRaw == null) {
      printInvalidInvocation('Specify a file to run.');
      return;
    }

    final String root = p.current;
    final String entrypoint = p.absolute(entrypointRaw);

    late final ProgramConstant program;
    try {
      program = await Compiler.compileProject(
        root: root,
        entrypoint: entrypoint,
        options: CompilerOptions(
          disablePrint: disablePrint,
        ),
      );
    } catch (err) {
      print('Compilation of "$entrypoint" failed.');
      println();
      print(err);
    }

    try {
      final VM vm = VM(
        program,
        VMOptions(
          disablePrint: disablePrint,
          printPrefix: '',
        ),
      );
      await vm.run();
    } catch (err) {
      print(err);
    }
  }

  static const String disablePrintFlag = 'disable-print';
}
