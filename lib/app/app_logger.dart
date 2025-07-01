import "package:logger/logger.dart";

Logger getLogger(String name) {
  return Logger(printer: SimplePrinter(colors: true, printTime: true));
}
