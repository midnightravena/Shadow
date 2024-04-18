typedef ReporterLogFn = void Function(String report);
class Reporter {
  const Reporter({
    this.log = defaultLog,
  });

  final ReporterLogFn? log;

  void reportError(final String name, final String text) {
    final String output = '[error] $name: $text';
    log?.call(output);
  }

  static void defaultLog(final String report) {
    print(report);
  }
}
