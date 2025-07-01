import "package:buzzer/mvvm/view_model_builder.dart";
import "package:flutter/widgets.dart";

abstract class MvvmView<T extends ChangeNotifier> extends StatelessWidget {
  Widget builder(BuildContext context, T viewModel, Widget? child);

  T viewModelBuilder(BuildContext context);

  bool get createNewViewModelOnInsert => false;

  bool get disposeViewModel => true;

  bool get initialiseSpecialViewModelsOnce => false;

  bool get fireOnViewModelReadyOnce => false;

  void onViewModelReady(T viewModel) {}

  void onDispose(T viewModel) {}

  Widget? staticChildBuilder(BuildContext context) => null;

  const MvvmView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<T>(
      builder: builder,
      viewModelBuilder: () => viewModelBuilder(context),
      staticChild: staticChildBuilder(context),
      onViewModelReady: onViewModelReady,
      onDispose: onDispose,
      disposeViewModel: disposeViewModel,
      createNewViewModelOnInsert: createNewViewModelOnInsert,
      initialiseSpecialViewModelsOnce: initialiseSpecialViewModelsOnce,
      fireOnViewModelReadyOnce: fireOnViewModelReadyOnce,
    );
  }
}
