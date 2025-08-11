import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:shadcn_ui/shadcn_ui.dart";

/// A draggable bottom sheet for displaying player information.
class BottomDrawer extends StatefulWidget {
  /// The builder function that provides the content of the bottom drawer.
  final Widget Function(ScrollController? scrollController) builder;

  /// Creates a [BottomDrawer] widget.
  const BottomDrawer({super.key, required this.builder});

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  double _sheetPosition = 0.1;

  final double _dragSensitivity = 600;

  final double _minSheetSize = 0.1;
  final double _maxSheetSize = 0.5;

  bool get _isOnDesktopAndWeb =>
      kIsWeb ||
      switch (defaultTargetPlatform) {
        TargetPlatform.macOS ||
        TargetPlatform.linux ||
        TargetPlatform.windows => true,
        TargetPlatform.android ||
        TargetPlatform.iOS ||
        TargetPlatform.fuchsia => false,
      };

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: _sheetPosition, // Start small
      minChildSize: _minSheetSize,
      maxChildSize: _maxSheetSize, // Only cover 40% of screen when open
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Column(
            children: [
              _Grabber(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _sheetPosition -= details.delta.dy / _dragSensitivity;
                    if (_sheetPosition < _minSheetSize) {
                      _sheetPosition = _minSheetSize;
                    }
                    if (_sheetPosition > _maxSheetSize) {
                      _sheetPosition = _maxSheetSize;
                    }
                  });
                },
                isOnDesktopAndWeb: _isOnDesktopAndWeb,
              ),
              Expanded(
                child: Builder(
                  builder: (context) => widget.builder(
                    _isOnDesktopAndWeb ? null : scrollController,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber({
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);

    var grabber = Container(
      width: 40,
      height: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          width: 32.0,
          height: 4.0,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );

    if (!isOnDesktopAndWeb) {
      return grabber;
    }

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: grabber,
    );
  }
}
