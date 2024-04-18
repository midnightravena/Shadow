import 'package:shared/shared.dart';
import 'output.dart';

class Disassembler {
  Disassembler(this.program, this.chunk, this.output);

  final ProgramConstant program;
  final Chunk chunk;
  final DisassemblerOutput output;

  int ip = 0;

  void dissassemble({
    final bool printHeader = true,
  }) {
    if (printHeader) {
      write('Offset{s}OpCode{s}Position');
    }
    while (ip < chunk.length) {
      ip += dissassembleInstruction();
      ip++;
    }
  }
