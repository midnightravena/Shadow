import '../chunk.dart';
import 'constant.dart';

class FunctionConstant {
  FunctionConstant({
    required this.moduleIndex,
    required this.isAsync,
    required this.arguments,
    required this.chunk,
  });

  factory FunctionConstant.deserialize(
    final SerializedConstant serialized,
  ) =>
      FunctionConstant(
        moduleIndex: serialized[0] as int,
        isAsync: serialized[1] == 1,
        arguments: (serialized[2] as List<dynamic>).cast<int>(),
        chunk: Chunk.deserialize(
          serialized[3] as SerializedConstant,
        ),
      );

  final int moduleIndex;
  final bool isAsync;
  final List<int> arguments;
  final Chunk chunk;

  SerializedConstant serialize() => <dynamic>[
        moduleIndex,
        if (isAsync) 1 else 0,
        arguments,
        chunk.serialize(),
      ];
}
