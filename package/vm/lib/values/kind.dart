enum ValueKind {
  boolean,
  function,
  nativeFunction,
  nativeAsyncFunction,
  unawaited,
  nullValue,
  number,
  string,
  object,
  list,
  module,
  primitiveObject,
  exception,
}

final Map<ValueKind, String> _kindCodeMap = <ValueKind, String>{
  ValueKind.boolean: 'Boolean',
  ValueKind.function: 'Function',
  ValueKind.nativeFunction: 'NativeFunction',
  ValueKind.nativeAsyncFunction: 'NativeAsyncFunction',
  ValueKind.unawaited: 'Unawaited',
  ValueKind.nullValue: 'Null',
  ValueKind.number: 'Number',
  ValueKind.string: 'String',
  ValueKind.object: 'Object',
  ValueKind.list: 'List',
  ValueKind.module: 'Module',
  ValueKind.primitiveObject: 'PrimitiveObject',
  ValueKind.exception: 'Exception',
};

extension ValueKindUtils on ValueKind {
  String get code => _kindCodeMap[this]!;
}
