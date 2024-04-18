abstract class DisassemblerOutput {
  void write(final String text);

  DisassemblerConsoleOutput get nested;
}

class DisassemblerConsoleOutput extends DisassemblerOutput {
  DisassemblerConsoleOutput([this.spaces = 0]);

  int spaces;

  @override
  void write(final String text) {
    print('$prefix$text');
  }

  @override
  DisassemblerConsoleOutput get nested => DisassemblerConsoleOutput(spaces + 1);

  String get prefix => '  ' * spaces;
}
