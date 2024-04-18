import 'package:compiler/compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] While (1)';
  final ProgramConstant program = await compileTestScript(
    'while_statement',
    'while1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0', 'c-1', 'c-2'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
