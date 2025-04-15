import 'package:logging/logging.dart' as logging;

class ErrorHandler {
  const ErrorHandler(this._service);

  final logging.Logger _service;

  Future<void> sendError(
    dynamic throwable,
    StackTrace stackTrace, {
    String? type,
    String? message,
  }) async {
    _service.severe("$type $message", throwable, stackTrace);
  }
}
