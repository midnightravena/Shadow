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

  int dissassembleInstruction() {
    final OpCodes opCode = chunk.opCodeAt(ip);
    switch (opCode) {
      case OpCodes.opConstant:
      case OpCodes.opDeclare:
      case OpCodes.opAssign:
      case OpCodes.opLookup:
        final int constantPosition = chunk.codeAt(ip + 1);
        final Constant constant = program.constantAt(constantPosition);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(constant [$constantPosition] = ${stringifyConstant(constant)})',
        );
        if (constant is FunctionConstant) {
          final List<String> argNames = constant.arguments
              .map((final int x) => '${program.constantAt(x)} (constant [$x])')
              .toList();
          output.write(
            '-> ${constant.isAsync ? 'async' : ''} ${argNames.join(', ')}',
          );
          Disassembler(program, constant.chunk, output.nested)
              .dissassemble(printHeader: false);
          output.write('<-');
        }
        return 1;

      case OpCodes.opJump:
      case OpCodes.opJumpIfFalse:
      case OpCodes.opJumpIfNull:
        final int offset = chunk.codeAt(ip + 1);
        final int absoluteOffset = ip + offset;
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(offset = $offset, absoluteOffset = $absoluteOffset)',
        );
        return 1;

        case OpCodes.opAbsoluteJump:
        case OpCodes.opBeginTry:
        final int offset = chunk.codeAt(ip + 1);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(absoluteOffset = $offset)',
        );
        return 1;

      case OpCodes.opCall:
      case OpCodes.opList:
      case OpCodes.opObject:
        final int popCount = chunk.codeAt(ip + 1);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(popCount = $popCount)',
        );
        return 1;

        case OpCodes.opImport:
        final int moduleIndex = chunk.codeAt(ip + 1);
        final int nameIndex = program.modules[moduleIndex];
        final String moduleName = program.constantAt(nameIndex) as String;
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(module [$moduleIndex] = $moduleName)',
        );
        return 1;

        default:
        writeInstruction(opCode, ip, chunk.lineAt(ip));
        return 0;
    }
  }

  void writeInstruction(
    final OpCodes opCode,
    final int offset,
    final int position, [
    final String extra = '',
  ]) {
    write('$offset{s}${opCode.name}{s}$position$extra');
  }

  void write(final String text) {
    output.write(text.replaceAll('{s}', _space).replaceAll('{so}', _spaceOnly));
  }

  static const String _space = '  |  ';
  static const String _spaceOnly = '  ';
