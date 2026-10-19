import 'package:logger/logger.dart';

final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

extension LogExtension on Object? {
  void logV() => _logger.t(toString());

  void logE() => _logger.e(toString());
}
