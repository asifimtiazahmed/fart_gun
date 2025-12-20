// Package imports:
import 'package:logger/logger.dart';

class AppLogger {
  final Logger logger = Logger();
  void i(String message) {
    logger.i(message);
  }

  void w(String message) {
    logger.w(message);
  }

  void d(String message) {
    logger.d(message);
  }

  void e(Object message) {
    logger.e(message);
  }
}
