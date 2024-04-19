import 'constants/exports.dart';
import 'op_codes.dart';

class Chunk {
  Chunk({
    required this.codes,
    required this.lines,
  });

  factory Chunk.empty() => Chunk(codes: <int>[], lines: <int>[]);

  factory Chunk.deserialize(final SerializedConstant serialized) => Chunk(
        codes: (serialized[0] as List<dynamic>).cast<int>(),
        lines: (serialized[1] as List<dynamic>).cast<int>(),
      );

  final List<int> codes;
  final List<int> lines;

  int addOpCode(final OpCodes opCode, final int line) =>
      addCode(opCode.index, line);

  int addCode(final int code, final int line) {
    codes.add(code);
    lines.add(line);
    return length - 1;
  }

  int codeAt(final int index) => codes[index];

  OpCodes opCodeAt(final int index) => OpCodes.values[codeAt(index)];

  int lineAt(final int index) => lines[index];

  SerializedConstant serialize() => <dynamic>[codes, lines];

  int get length => codes.length;
}
