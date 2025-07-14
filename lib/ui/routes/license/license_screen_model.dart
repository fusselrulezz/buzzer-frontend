import "package:buzzer/mvvm/future_view_model.dart";
import "package:flutter/foundation.dart";

/// The view model for the License screen, managing the state and logic
/// for displaying the licenses of the application and its dependencies.
class LicenseScreenModel extends FutureViewModel<LicenseData> {
  String? _selectedPackage;

  /// The currently selected package for which the license is displayed.
  String? get selectedPackage => _selectedPackage;

  /// Whether a package is selected or not.
  bool get hasSelected => _selectedPackage != null;

  @override
  Future<LicenseData> futureToRun() async {
    return await LicenseData.resolve();
  }

  /// Happens when a license is selected.
  void onSelectLicense(String packageName) {
    _selectedPackage = packageName;
    rebuildUi();
  }
}

/// Stores the license data for the application and its dependencies.
class LicenseData {
  /// The list of license entries for the application and its dependencies.
  final List<LicenseEntry> entries = [];

  /// Maps package names to the indices of the licenses that belong to them.
  final Map<String, List<int>> packageLicenseBindings = <String, List<int>>{};

  /// The list of package names that have licenses.
  final List<String> packages = <String>[];

  /// The first package that has a license, used for display purposes.
  String? firstPackage;

  /// Creates a new instance of [LicenseData].
  LicenseData();

  /// Resolves the licenses from the [LicenseRegistry] and returns a [LicenseData]
  /// instance containing all the licenses and their associated packages.
  static Future<LicenseData> resolve() async {
    final entries = await LicenseRegistry.licenses.toList();

    final folded = entries.fold(
      LicenseData(),
      (LicenseData previous, LicenseEntry entry) => previous..addLicense(entry),
    );

    return folded;
  }

  /// Adds a license entry to the data structure, associating it with the
  /// packages it belongs to.
  void addLicense(LicenseEntry entry) {
    // Before the license can be added, we must first record the packages to
    // which it belongs.
    for (final String package in entry.packages) {
      _addPackage(package);
      // Bind this license to the package using the next index value. This
      // creates a contract that this license must be inserted at this same
      // index value.
      packageLicenseBindings[package]!.add(entries.length);
    }
    entries.add(entry); // Completion of the contract above.
  }

  /// Add a package and initialize package license binding. This is a no-op if
  /// the package has been seen before.
  void _addPackage(String package) {
    if (!packageLicenseBindings.containsKey(package)) {
      packageLicenseBindings[package] = <int>[];
      firstPackage ??= package;
      packages.add(package);
    }
  }
}
