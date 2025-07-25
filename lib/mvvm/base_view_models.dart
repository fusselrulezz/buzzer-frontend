import "dart:async";

import "package:flutter/widgets.dart";

import "builder_helpers.dart";
import "busy_error_state_helper.dart";
import "data_state_helper.dart";
import "listenable_service_mixin.dart";
import "message_state_helper.dart";

/// Contains ViewModel functionality for busy and error state management
class BaseViewModel extends ChangeNotifier
    with BuilderHelpers, BusyAndErrorStateHelper {
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
}

/// A [BaseViewModel] that provides functionality to subscribe to a reactive service.
abstract class ReactiveViewModel extends BaseViewModel {
  List<ListenableServiceMixin> _listenableServices = [];

  /// The list of listenable services.
  List<ListenableServiceMixin> get listenableServices => [];

  /// Creates a new [ReactiveViewModel] instance.
  ReactiveViewModel() {
    if (listenableServices.isNotEmpty) {
      _reactToServices(listenableServices);
    }
  }

  void _reactToServices(List<ListenableServiceMixin> listenableServices) {
    _listenableServices = listenableServices;
    for (var listenableService in _listenableServices) {
      listenableService.addListener(_indicateChange);
    }
  }

  @override
  void dispose() {
    for (var listenableService in _listenableServices) {
      listenableService.removeListener(_indicateChange);
    }

    super.dispose();
  }

  void _indicateChange() {
    notifyListeners();
  }
}

/// A [DynamicSourceViewModel] that can be used to notify the View when the
/// source changes.
@protected
class DynamicSourceViewModel<T> extends ReactiveViewModel {
  /// Whether the source has changed.
  bool changeSource = false;

  /// Notifies the View that the source has changed.
  void notifySourceChanged() {
    changeSource = true;
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [];
}

/// Interface: Additional actions that should be implemented by spcialised ViewModels
abstract class Initialisable {
  /// Initialises the ViewModel.
  void initialise();
}

/// A [StreamData] ViewModel that listens to a stream and updates the data
/// accordingly.
class StreamData<T> extends DynamicSourceViewModel<T>
    with MessageStateHelper, DataStateHelper<T> {
  /// The stream that this ViewModel listens to
  Stream<T> stream;

  /// Called when the new data arrives
  ///
  /// notifyListeners is called before this so no need to call in here unless you're
  /// running additional logic and setting a separate value.
  Function? onData;

  /// Called after the stream has been listened too
  Function? onSubscribed;

  /// Called when an error is placed on the stream
  Function? onError;

  /// Called when the stream is cancelled
  Function? onCancel;

  /// Allows you to modify the data before it's set as the new data for the ViewModel
  ///
  /// This can be used to modify the data if required. If nothhing is returned the data
  /// won't be set.
  Function? transformData;

  /// Creates a new [StreamData] instance.
  StreamData(
    this.stream, {
    this.onData,
    this.onSubscribed,
    this.onError,
    this.onCancel,
    this.transformData,
  });
  late StreamSubscription _streamSubscription;

  /// Initializes the stream and sets up the listeners.
  void initialise() {
    _streamSubscription = stream.listen(
      (incomingData) {
        setError(null);
        setMessage(null);
        // Extra security in case transformData isnt sent
        var interceptedData = transformData == null
            ? incomingData
            : transformData!(incomingData);

        if (interceptedData != null) {
          data = interceptedData;
        } else {
          data = incomingData;
        }

        notifyListeners();
        onData!(data);
      },
      onError: (error) {
        setError(error);
        data = null;
        onError!(error);
        notifyListeners();
      },
    );

    onSubscribed!();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    onCancel!();

    super.dispose();
  }
}
