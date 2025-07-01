import "package:buzzer/mvvm/busy_error_state_helper.dart";
import "package:flutter/widgets.dart";

class BaseViewModel extends ChangeNotifier with BusyAndErrorStateHelper {
  bool disposed = false;

  bool _initialised = false;
  bool get initialised => _initialised;

  bool _onModelReadyCalled = false;
  bool get onModelReadyCalled => _onModelReadyCalled;

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }

  /// Calls the builder function with this updated viewmodel
  void rebuildUi() {
    notifyListeners();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  /// Sets the initialised value for the ViewModel to true. This is called after
  /// the first initialise special ViewModel call
  void setInitialised(bool value) {
    _initialised = value;
  }

  /// Sets the onModelReadyCalled value to true. This is called after this first onModelReady call
  void setOnModelReadyCalled(bool value) {
    _onModelReadyCalled = value;
  }
}
