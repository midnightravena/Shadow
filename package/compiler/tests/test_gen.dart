// ignore_for_file: unreachable_from_main, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> main(final List<String> args) async {
  final TestOptions options = TestOptions(
    category: args[0],
    title: args[1],
    titleExtra: '',
    index: int.parse(args[2]),
    output: (json.decode(args[3]) as List<dynamic>).cast(),
    script: args[4],
  );
  await options.parentDir.ensure();
  print('Parent Dir: ${options.parentDirPath}');
  if (await options.File.exists()) {
    print('"${options.FilePath}" exists already.');
    return;
  }
  if (await options.dartTestFile.exists()) {
    print('"${options.dartTestFilePath}" exists already.');
    return;
  }
  await options.File.writeAsString(options.script);
  print('Beize File: ${options.FilePath}');
  await options.dartTestFile.writeAsString(generateTestDart(options: options));
  print('Dart File: ${options.dartTestFilePath}');
  print('');

  final Process testProcess = await Process.start(
    'dart',
    <String>['test', p.relative(options.dartTestFilePath)],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );
  await testProcess.exitCode;
}

class TestOptions {
  TestOptions({
    required this.category,
    required this.title,
    required this.titleExtra,
    required this.index,
    required this.output,
    required this.script,
  });

  final String category;
  final String title;
  final String titleExtra;
  final int index;
  final List<String> output;
  final String script;

  String toPathName(final String text) =>
      text.replaceAll(RegExp(r'\s+'), '_').toLowerCase();

  String get parentDirName => toPathName('${title}_$category');
  String get FileName => '$baseFileName.beize';
  String get dartTestFileName => '${baseFileName}_test.dart';

  String get baseFileName {
    final List<String> parts = <String>[
      toPathName(title),
      if (titleExtra != '') titleExtra,
      index.toString(),
    ];
    return parts.join('_');
  }

  String get parentDirPath => p.join(rootDir, parentDirName);
  String get FilePath => p.join(parentDirPath, FileName);
  String get dartTestFilePath => p.join(parentDirPath, dartTestFileName);

  Directory get parentDir => Directory(parentDirPath);
  File get File => File(FilePath);
  File get dartTestFile => File(dartTestFilePath);

  static final String rootDir = p.absolute('tests');
}

String generateTestDart({
  required final TestOptions options,
}) =>
    '''
import 'package:compiler/compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[${options.category}] ${options.title} (${options.index})';
  final ProgramConstant program = await compileTestScript(
    '${options.parentDirName}',
    '${options.FileName}',
  );

  test('\$title - Channel', () async {
    final List<String> expected = <String>[${options.output.map((final String x) => "'$x'").join(', ')}];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
''';

extension on Directory {
  Future<void> ensure() async {
    if (!(await exists())) {
      await create(recursive: true);
    }
  }
}
