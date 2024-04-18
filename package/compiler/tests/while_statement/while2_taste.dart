import 'package:compiler/compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] While (2)';
  final ProgramConstant program = await compileTestScript(
    'while_statement',
    'while2.shadow',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>[];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
