import "dart:convert";

import "package:buzzer/helper/ascii_only.dart";
import "package:easy_logger/easy_logger.dart";
import "package:logger/logger.dart";

/// Returns the a default [Logger] instance for the application.
Logger getLogger(String name) {
  return Logger(printer: _BuzzerLogPrinter(name: name));
}

/// A function that logs messages from the [EasyLogger] package using the
/// custom [_BuzzerLogPrinter].
void easyLoggerPrinter(
  Object object, {
  String? name,
  LevelMessages? level,
  StackTrace? stackTrace,
}) {
  final escapedName = name == null
      ? "EasyLogger"
      : AsciiOnly.filter(name).trim();
  final printer = _BuzzerLogPrinter(name: escapedName);

  final mappedLevel = switch (level) {
    LevelMessages.debug => Level.debug,
    LevelMessages.info => Level.info,
    LevelMessages.warning => Level.warning,
    LevelMessages.error => Level.error,
    _ => Level.info, // Default to info if no level is provided
  };

  final message = printer
      .log(
        LogEvent(
          mappedLevel,
          object,
          time: DateTime.now(),
          stackTrace: stackTrace,
        ),
      )
      .join("\n");

  if (message.isNotEmpty) {
    print(message);
  }
}

class _BuzzerLogPrinter extends LogPrinter {
  /// The name of the logger, used for identification in log messages.
  final String name;

  static const int _maxNameLength = 20;

  /// Creates a new instance of [_BuzzerLogPrinter] with the specified [name].
  _BuzzerLogPrinter({required this.name});

  @override
  List<String> log(LogEvent event) {
    return _lines(event).toList();
  }

  Iterable<String> _lines(LogEvent event) sync* {
    final buffer = StringBuffer();

    // Log level and color

    final prefix = _prefix(event.level);
    final color = _color(event.level);

    buffer.write("[");

    if (color.color) {
      buffer.write(color(prefix));
    } else {
      buffer.write(prefix);
    }

    buffer.write("] ");

    // Time

    final time = event.time.toIso8601String();

    buffer.write("[");
    buffer.write(time);
    buffer.write("] ");

    // Logger name

    buffer.write("[");
    buffer.write(name.padRight(_maxNameLength).substring(0, _maxNameLength));
    buffer.write("]: ");

    // Message

    final message = _extractMessage(event.message);
    buffer.write(message);

    // Error and stack trace

    if (event.error != null) {
      buffer.write("\n");
      buffer.writeln(event.error.toString());

      if (event.stackTrace != null) {
        buffer.writeln(event.stackTrace.toString());
      }
    }

    yield buffer.toString();
  }

  String _prefix(Level level) {
    return switch (level) {
      Level.trace => "T",
      Level.debug => "D",
      Level.info => "I",
      Level.warning => "W",
      Level.error => "E",
      Level.fatal => "F",
      _ => "",
    };
  }

  AnsiColor _color(Level level) {
    return switch (level) {
      Level.trace => AnsiColor.fg(AnsiColor.grey(0.5)),
      Level.debug => const AnsiColor.none(),
      Level.info => const AnsiColor.fg(12),
      Level.warning => const AnsiColor.fg(208),
      Level.error => const AnsiColor.fg(196),
      Level.fatal => const AnsiColor.fg(199),
      _ => const AnsiColor.none(),
    };
  }

  String _extractMessage(message) {
    final finalMessage = message is Function ? message() : message;

    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}
