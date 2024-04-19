import 'constant.dart';
import 'function.dart';

class ProgramConstant {
  ProgramConstant({
    required this.modules,
    required this.constants,
  });

  factory ProgramConstant.deserialize(
    final SerializedConstant serialized,
  ) =>
      ProgramConstant(
        modules: (serialized[0] as List<dynamic>).cast<int>(),
        constants: (serialized[1] as List<dynamic>).map((final dynamic x) {
          if (x is List<dynamic>) {
            return FunctionConstant.deserialize(x);
          }
          return x;
        }).toList(),
      );

  final List<int> modules;
  final List<Constant> constants;

  String moduleNameAt(final int index) => constantAt(modules[index]) as String;

  FunctionConstant moduleFunctionAt(final int index) =>
      constantAt(modules[index + 1]) as FunctionConstant;

  Constant constantAt(final int index) => constants[index];

  SerializedConstant serialize() => <dynamic>[
        modules,
        constants.map((final Constant x) {
          if (x is FunctionConstant) return x.serialize();
          return x;
        }).toList(),
      ];
}
