import "package:flutter/foundation.dart";

/// Adds functionality to easily listen to all reactive values in a service
mixin ListenableServiceMixin {
  final List<Function> _listeners = List<Function>.empty(growable: true);

  /// Returns the number of listeners currently registered with this service
  int get listenersCount => _listeners.length;

  /// List to the values and react when there are any changes
  void listenToReactiveValues(List<dynamic> reactiveValues) {
    for (var reactiveValue in reactiveValues) {
      if (reactiveValue is ChangeNotifier) {
        reactiveValue.addListener(notifyListeners);
      }
      //else if (reactiveValue is ReactiveValue) {
      //  reactiveValue.values.listen((value) => notifyListeners());
      //} else if (reactiveValue is ReactiveList) {
      //  reactiveValue.onChange.listen((event) => notifyListeners());
      //}
    }
  }

  /// Registers a listener with this service
  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  /// Removes a listener from the service
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  /// Notifies all the listeners attached to this service
  @protected
  @visibleForTesting
  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
}
