/// A mixin for services that require initialization before use.
abstract mixin class InitializableService {
  /// Initializes the service.
  Future<void> init();
}
