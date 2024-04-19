import '../bytecode.dart';

class UnknownConstantExpection implements Exception {
  UnknownConstantExpection(this.message);

  factory UnknownConstantExpection.unknownSerializedConstant(
    final Constant constant,
  ) =>
      UnknownConstantExpection('Unknown serialized constant: $constant');

  final String message;

  @override
  String toString() => 'UnknownConstantExpection: $message';
}
