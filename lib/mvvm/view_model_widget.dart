import "package:flutter/widgets.dart";
import "package:provider/provider.dart";

/// A widget that provides a value passed through a provider as a parameter of
/// the build function.
abstract class ViewModelWidget<T> extends Widget {
  /// Whether the widget should rebuild when the view model changes.
  final bool reactive;

  /// Creates a new [ViewModelWidget] instance.
  const ViewModelWidget({super.key, this.reactive = true});

  /// Builds the widget based on the provided view model.
  @protected
  Widget build(BuildContext context, T viewModel);

  @override
  ComponentElement createElement() => _DataProviderElement<T>(this);
}

class _DataProviderElement<T> extends ComponentElement {
  _DataProviderElement(super.widget);

  @override
  ViewModelWidget get widget => super.widget as ViewModelWidget<dynamic>;

  @override
  Widget build() =>
      widget.build(this, Provider.of<T>(this, listen: widget.reactive));

  @override
  void update(ViewModelWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild(force: true);
  }
}
