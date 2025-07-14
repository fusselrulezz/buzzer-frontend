import "package:auto_route/auto_route.dart";
import "package:buzzer/ui/routes/license/license_text_display.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart" show ListTile, Ink;
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";

import "license_screen_model.dart";

/// A screen that displays the licenses of the application and its dependencies.
/// This screen is typically used to inform users about the open-source licenses
/// of the libraries and frameworks used in the application.
@RoutePage()
class LicenseScreen extends MvvmView<LicenseScreenModel> {
  /// The translation prefix for the license screen.
  static const trPrefix = "routes.license";

  /// Creates a new [LicenseScreen] widget.
  const LicenseScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    LicenseScreenModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      child: ResizablePanel.horizontal(
        draggerBuilder: (context) => const HorizontalResizableDragger(),
        children: [
          ResizablePane(
            initialSize: 400.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      OutlineButton(
                        shape: ButtonShape.rectangle,
                        onPressed: () => context.pop(),
                        child: Icon(BootstrapIcons.chevronLeft),
                      ),
                      const SizedBox(width: 8.0),
                      Text("$trPrefix.title".tr()),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: viewModel.isBusy
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: viewModel.data?.entries.length ?? 0,
                          itemBuilder: (context, index) {
                            final data = viewModel.data;

                            if (data == null) {
                              return const SizedBox.shrink();
                            }

                            final packageName = data.packages[index];
                            final selected =
                                packageName == viewModel.selectedPackage;

                            return Ink(
                              decoration: BoxDecoration(color: Colors.amber),
                              child: ListTile(
                                title: selected
                                    ? Text(packageName).bold
                                    : Text(packageName),
                                onTap: () =>
                                    viewModel.onSelectLicense(packageName),
                                selected: selected,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          ResizablePane.flex(child: _buildLicenseDetails(viewModel)),
        ],
      ),
    );
  }

  Widget _buildLicenseSelectPrompt() {
    return Center(child: Text("$trPrefix.select_license".tr()));
  }

  Widget _buildLicenseDetails(LicenseScreenModel viewModel) {
    final packageName = viewModel.selectedPackage;
    final data = viewModel.data;

    if (data == null || packageName == null) {
      return _buildLicenseSelectPrompt();
    }

    final bindings = data.packageLicenseBindings[packageName];

    if (bindings == null || bindings.isEmpty) {
      return Center(child: Text("$trPrefix.no_licenses".tr()));
    }

    final licenses = bindings
        .map((int i) => data.entries[i])
        .toList(growable: false);

    return LicenseTextDisplay(
      key: ValueKey(packageName),
      packageName: packageName,
      licenses: licenses,
    );
  }

  @override
  LicenseScreenModel viewModelBuilder(BuildContext context) =>
      LicenseScreenModel();
}
