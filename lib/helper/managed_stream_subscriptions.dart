import 'dart:async';

import 'package:buzzer/app/app.logger.dart';
import 'package:logger/logger.dart';

/// A mixin to manage and dispose of multiple [StreamSubscription] instances.
/// This mixin provides methods to add subscriptions and dispose of them when
/// no longer needed.
mixin ManagedStreamSubscriptions {
  final Logger _logger = getLogger("ManagedStreamSubscriptions");

  final List<StreamSubscription> _subscriptions = [];

  /// Adds a single [StreamSubscription] instance to the list of managed
  /// subscriptions.
  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Adds multiple [StreamSubscription] instances to the list of managed
  /// subscriptions.
  void addSubscriptions(Iterable<StreamSubscription> subscriptions) {
    _subscriptions.addAll(subscriptions);
  }

  /// Disposes all managed [StreamSubscription] instances and clears the
  /// list of subscriptions by this mixin.
  Future<void> disposeSubscriptions() async {
    if (_subscriptions.isEmpty) {
      return;
    }

    final int count = _subscriptions.length;

    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }

    _subscriptions.clear();

    _logger.i("Disposed $count stream subscriptions.");
  }
}
