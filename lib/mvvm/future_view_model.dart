import "package:buzzer/mvvm/base_view_models.dart";
import "package:buzzer/mvvm/data_state_helper.dart";
import "package:buzzer/mvvm/message_state_helper.dart";

/// Provides functionality for a ViewModel that's sole purpose it is to fetch data using a [Future]
/// This class is mixed with mixins:
/// - [MessageStateHelper]
/// - [DataStateHelper]
abstract class FutureViewModel<T> extends DynamicSourceViewModel<T>
    with MessageStateHelper, DataStateHelper<T>
    implements Initialisable {
  /// The future that fetches the data and sets the view to busy
  Future<T> futureToRun();

  /// Indicates if you want the error caught in futureToRun to be rethrown
  bool get rethrowException => false;

  @override
  Future initialise() async {
    setError(null);
    setMessage(null);
    setBusy(true);

    try {
      data = await runBusyFuture<T?>(futureToRun(), throwException: true);
    } catch (exception, stackTrace) {
      setError(exception);
      setBusy(false);
      onError(exception, stackTrace);

      notifyListeners();
      if (rethrowException) {
        rethrow;
      }

      return null;
    }

    if (data != null) {
      onData(data);
    }

    changeSource = false;
  }

  /// Called when an error occurs within the future being run
  void onError(dynamic error, StackTrace? stackTrace) {}

  /// Called after the data has been set
  void onData(T? data) {}
}
