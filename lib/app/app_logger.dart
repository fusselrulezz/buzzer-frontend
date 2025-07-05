import "package:logger/logger.dart";

/// Returns the a default [Logger] instance for the application.
Logger getLogger(String name) {
  return Logger(printer: SimplePrinter(colors: true, printTime: true));
}
