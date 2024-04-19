import '../../errors/exports.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class FunctionValueUtils {
  static InterpreterResult handleException(
    final CallFrame frame,
    final Object err,
    final StackTrace stackTrace,
  ) =>
      InterpreterResult.fail(createExceptionValue(frame, err, stackTrace));

  static ExceptionValue createExceptionValue(
    final CallFrame frame,
    final Object err,
    final StackTrace stackTrace,
  ) {
    if (err is InterpreterBridgedException) {
      return err.error;
    }
    return ExceptionValue(
      err is NativeException ? err.message : err.toString(),
      frame.getStackTrace(),
      stackTrace.toString(),
    );
  }
}
