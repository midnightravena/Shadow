import '../lexer/exports.dart';

class Span {
  const Span(this.start, this.end);

  factory Span.fromSingleCursor(final Cursor cursor) => Span(cursor, cursor);

  final Cursor start;
  final Cursor end;

  @override
  String toString() => isSameCursor ? start.toString() : '$start - $end';

  bool get isSameCursor => start.position == end.position;
}
