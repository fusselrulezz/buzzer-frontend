import "dart:convert";
import "dart:math";

import "package:flutter/services.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/initializable_service.dart";
import "package:buzzer/model/random_names.dart";

/// Service for generating random names using predefined adjectives and nouns.
class RandomNameService with InitializableService {
  final _logger = getLogger("RandomNameService");

  RandomNames? _randomNames;

  /// Determines if the service has been initialized with random names.
  /// Returns `true` if random names are available, `false` otherwise.
  bool get hasRandomNames => _randomNames != null;

  @override
  Future<void> init() async {
    try {
      var data = await rootBundle.loadString("assets/config/random_names.json");
      var jsonResult = jsonDecode(data);
      _randomNames = RandomNames.fromJson(jsonResult);
    } catch (e, stack) {
      _logger.e("Failed to load random names.", error: e, stackTrace: stack);
      rethrow;
    }

    if (_randomNames != null) {
      _logger.i("Random names initialized successfully.");
    }
  }

  /// Generates a random name by combining a random adjective and a random noun.
  /// Throws a [StateError] if the random names have not been initialized.
  ///
  /// Check [hasRandomNames] before calling this method to ensure that random names are available.
  String getRandomName() {
    if (_randomNames == null) {
      throw StateError("Random names not initialized.");
    }

    final random = Random();
    final adjective = _randomNames!
        .adjectives[random.nextInt(_randomNames!.adjectives.length)];
    final noun =
        _randomNames!.nouns[random.nextInt(_randomNames!.nouns.length)];

    return "$adjective$noun";
  }
}
