import '../errors/runtime_exception.dart';
import '../values/exports.dart';
import 'natives/exports.dart';

class Namespace {
  Namespace([this.parent]);

  factory Namespace.withNatives() {
    final Namespace namespace = Namespace();
    Natives.bind(namespace);
    return namespace;
  }

  final Namespace? parent;
  final Map<String, Value> values = <String, Value>{};

  Value lookup(final String name) {
    if (!values.containsKey(name)) {
      if (parent == null) {
        throw RuntimeExpection.undefinedVariable(name);
      }
      return parent!.lookup(name);
    }
    return values[name]!;
  }

  Value? lookupOrNull(final String name) =>
      values[name] ?? parent?.lookupOrNull(name);

  void declare(final String name, final Value value) {
    if (values.containsKey(name)) {
      throw RuntimeExpection.cannotRedecalreVariable(name);
    }
    values[name] = value;
  }

  void assign(final String name, final Value value) {
    if (!values.containsKey(name)) {
      if (parent == null) {
        throw RuntimeExpection.undefinedVariable(name);
      }
      return parent!.assign(name, value);
    }
    values[name] = value;
  }

  Namespace get enclosed => Namespace(this);
}
