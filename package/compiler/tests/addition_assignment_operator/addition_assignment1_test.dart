import 'package:compiler/compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Addition Assignment (1)';
  final ProgramConstant program = await compileTestScript(
    'addition_assignment_operator',
    'addition_assignment1.shadow',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['3'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
