import '../namespace.dart';
import 'exports.dart';

abstract class Natives {
  static void bind(final Namespace namespace) {
    BooleanNatives.bind(namespace);
    ConvertNatives.bind(namespace);
    DateTimeNatives.bind(namespace);
    ExceptionNatives.bind(namespace);
    FiberNatives.bind(namespace);
    FunctionNatives.bind(namespace);
    ListNatives.bind(namespace);
    MathNatives.bind(namespace);
    NumberNatives.bind(namespace);
    ObjectNatives.bind(namespace);
    RegExpNatives.bind(namespace);
    StringNatives.bind(namespace);
    GlobalsNatives.bind(namespace);
    UnawaitedNatives.bind(namespace);
  }
}
