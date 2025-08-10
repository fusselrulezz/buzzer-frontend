import "package:auto_route/auto_route.dart";
import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "package:buzzer/mvvm/view_model_widget.dart";

import "license_screen.dart";
import "license_screen_model.dart";
import "license_text_display.dart";

/// The desktop variant of the license screen.
class LicenseScreenDesktop extends ViewModelWidget<LicenseScreenModel> {
  /// The translation prefix for the license screen.
  static const trPrefix = LicenseScreen.trPrefix;

  /// Creates a new [LicenseScreenDesktop] widget.
  const LicenseScreenDesktop({super.key});

  @override
  Widget build(BuildContext context, LicenseScreenModel viewModel) {
    return Scaffold(
      body: ShadResizablePanelGroup(
        children: [
          ShadResizablePanel(
            id: 0,
            defaultSize: .3,
            minSize: 0.2,
            maxSize: 0.5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ShadButton.outline(
                        onPressed: () => context.pop(),
                        child: Icon(BootstrapIcons.chevron_left),
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
                              //decoration: BoxDecoration(color: Colors.amber),
                              child: ListTile(
                                title: selected
                                    ? Text(
                                        packageName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
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
          ShadResizablePanel(
            id: 1,
            defaultSize: .8,
            child: Align(
              alignment: Alignment.topLeft,
              child: _buildLicenseDetails(viewModel),
            ),
          ),
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
}
