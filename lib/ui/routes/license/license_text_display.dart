import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";

/// A widget that displays the text of a license for a given package.
class LicenseTextDisplay extends StatefulWidget {
  /// The name of the package for which the license is displayed.
  final String packageName;

  /// The list of licenses associated with the package.
  final List<LicenseEntry> licenses;

  /// Creates a new [LicenseTextDisplay] widget.
  const LicenseTextDisplay({
    super.key,
    required this.packageName,
    required this.licenses,
  });

  @override
  State<LicenseTextDisplay> createState() => _LicenseTextDisplayState();
}

class _LicenseTextDisplayState extends State<LicenseTextDisplay> {
  final List<Widget> _items = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadLicenses();
  }

  Future<void> _loadLicenses() async {
    for (int i = 0; i < widget.licenses.length; i++) {
      final license = widget.licenses[i];

      if (!mounted) {
        return;
      }

      final List<LicenseParagraph> paragraphs = await SchedulerBinding.instance
          .scheduleTask<List<LicenseParagraph>>(
            license.paragraphs.toList,
            Priority.animation,
            debugLabel: "License",
          );

      if (!mounted) {
        return;
      }

      _items.add(_buildLicense(paragraphs));

      if (i < widget.licenses.length - 1) {
        _items.addAll([
          const SizedBox(height: 16.0),
          const Divider(),
          const SizedBox(height: 16.0),
        ]);
      }
    }

    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._items,
            if (!_loaded) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildLicense(List<LicenseParagraph> paragraphs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildLicenseParagraphs(paragraphs).toList(growable: false),
    );
  }

  Iterable<Widget> _buildLicenseParagraphs(
    List<LicenseParagraph> paragraphs,
  ) sync* {
    for (final paragraph in paragraphs) {
      if (paragraph.text.isEmpty) {
        continue; // Skip empty paragraphs
      }

      if (paragraph.indent == LicenseParagraph.centeredIndent) {
        yield Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            paragraph.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      } else {
        yield Padding(
          padding: EdgeInsetsDirectional.only(
            top: 8.0,
            start: 16.0 * paragraph.indent,
          ),
          child: Text(paragraph.text),
        );
      }
    }
  }
}
