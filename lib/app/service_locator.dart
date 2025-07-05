import "package:get_it/get_it.dart";

/// Convenience getter to access the service locator instance.
final locator = ServiceLocator.instance;

/// The service locator class that provides a singleton instance of GetIt.
/// This class is used to register and retrieve services throughout the
/// application.
class ServiceLocator {
  static ServiceLocator? _instance;

  /// The GetIt instance used for service registration and retrieval.
  GetIt locator;

  ServiceLocator._(GetIt instance) : locator = instance;

  /// Returns the singleton instance of the service locator.
  /// If the instance does not yet exist, a new one will be created.
  static ServiceLocator get instance {
    _instance ??= ServiceLocator._(GetIt.instance);
    return _instance!;
  }

  /// Retrieves a service of type [T] from the locator.
  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) => locator.get<T>(
    instanceName: instanceName,
    param1: param1,
    param2: param2,
  );

  /// Registers a singleton service of type [T] in the locator.
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
    Set<String>? registerFor,
  }) {
    locator.registerSingleton<T>(
      instance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: dispose,
    );
  }

  /// Registers a factory for a service of type [T] in the locator.
  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> factoryfunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
    Set<String>? registerFor,
  }) {
    locator.registerLazySingleton<T>(
      factoryfunc,
      instanceName: instanceName,
      dispose: dispose,
    );
  }

  /// Enables calling an instance of this class as a function to retrieve
  /// a service of type [T].
  /// This allows for a more concise syntax when accessing services.
  ///
  /// This enables us to use `locator<T>()` instead of `locator.get<T>()`.
  T call<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) => locator<T>(instanceName: instanceName, param1: param1, param2: param2);
}
