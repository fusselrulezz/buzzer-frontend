import "package:flutter/widgets.dart";
import "package:provider/provider.dart";

import "base_view_model.dart";

enum ViewModelBuilderType { nonReactive, reactive }

/// A widget that provides base functionality for the Mvvm style provider architecture by FilledStacks.
class ViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final Widget? staticChild;

  /// Fires once when the ViewModel is created or set for the first time
  ///
  /// If you want this to fire everytime the widget is inserted set [createNewViewModelOnInsert] to true
  final Function(T viewModel)? onViewModelReady;

  /// Builder function with access to the ViewModel to build UI form
  final Widget Function(BuildContext context, T viewModel, Widget? child)
  builder;

  /// A builder function that returns the ViewModel for this widget
  final T Function() viewModelBuilder;

  /// Indicates if you want Provider to dispose the ViewModel when it's removed from the widget tree.
  ///
  /// default's to true
  final bool disposeViewModel;

  /// When set to true a new ViewModel will be constructed everytime the widget is inserted.
  ///
  /// When setting this to true make sure to handle all disposing of streams if subscribed
  /// to any in the ViewModel. [onViewModelReady] will fire once the ViewModel has been created/set.
  /// This will be used when on re-insert of the widget the ViewModel has to be constructed with
  /// a new value.
  final bool createNewViewModelOnInsert;

  final ViewModelBuilderType providerType;

  /// Indicates if the onViewModelReady should fire every time the ViewModel is inserted into the widget tree.
  /// Or only once during the lifecycle of the ViewModel.
  final bool fireOnViewModelReadyOnce;

  /// Indicates if we should run the initialise functionality for special ViewModels only once
  final bool initialiseSpecialViewModelsOnce;

  /// Fires when the widget has been removed from the widget tree and allows you to dispose
  /// of any controllers or state values that need disposing
  final Function(T viewModel)? onDispose;

  /// Constructs a ViewModel provider that fires the [builder] function when notifyListeners is called in the ViewModel.
  const ViewModelBuilder({
    required this.viewModelBuilder,
    required this.builder,
    this.staticChild,
    this.onViewModelReady,
    this.onDispose,
    this.disposeViewModel = true,
    this.createNewViewModelOnInsert = false,
    this.fireOnViewModelReadyOnce = false,
    this.initialiseSpecialViewModelsOnce = false,
    super.key,
  }) : providerType = ViewModelBuilderType.reactive;

  @override
  ViewModelBuilderState<T> createState() => ViewModelBuilderState<T>();
}

class ViewModelBuilderState<T extends ChangeNotifier>
    extends State<ViewModelBuilder<T>> {
  T? _viewModel;

  @override
  void initState() {
    super.initState();
    // We want to ensure that we only build the ViewModel if it hasn't been built yet.
    if (_viewModel == null) {
      _createViewModel();
    }
    // Or if the user wants to create a new ViewModel whenever initState is fired
    else if (widget.createNewViewModelOnInsert) {
      _createViewModel();
    }
  }

  void _createViewModel() {
    _viewModel = widget.viewModelBuilder();

    // Fire onViewModelReady after the ViewModel has been constructed
    if (widget.onViewModelReady != null) {
      if (widget.fireOnViewModelReadyOnce &&
          !(_viewModel as BaseViewModel).onModelReadyCalled) {
        widget.onViewModelReady!(_viewModel!);
        (_viewModel as BaseViewModel?)?.setOnModelReadyCalled(true);
      } else if (!widget.fireOnViewModelReadyOnce) {
        widget.onViewModelReady!(_viewModel!);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(_viewModel!);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.disposeViewModel) {
      return ChangeNotifierProvider<T>.value(
        value: _viewModel!,
        child: widget.builder(context, _viewModel!, widget.staticChild),
      );
    }

    return ChangeNotifierProvider<T>(
      create: (context) => _viewModel!,
      child: widget.builder(context, _viewModel!, widget.staticChild),
    );
  }
}
