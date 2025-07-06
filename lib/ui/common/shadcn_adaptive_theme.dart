import "package:adaptive_theme/adaptive_theme.dart";
import "package:flutter/foundation.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

/// A builder function that takes the current context and provides
/// the light and dark themes to build the widget tree.
typedef ShadcnAdaptiveThemeBuilder =
    Widget Function(BuildContext context, ThemeData light, ThemeData dark);

/// A widget that provides adaptive theming capabilities using the
/// `adaptive_theme` package.
class ShadcnAdaptiveTheme extends StatefulWidget {
  /// The light theme to use when the mode is light.
  final ThemeData light;

  /// The dark theme to use when the mode is dark.
  final ThemeData dark;

  /// The initial theme mode to use when the widget is first built.
  final AdaptiveThemeMode initial;

  /// The builder function that builds the widget tree based on the current
  /// theme and mode.
  final ShadcnAdaptiveThemeBuilder builder;

  /// Whether to show a floating theme button for debugging purposes.
  final bool debugShowFloatingThemeButton;

  /// The key used to store the adaptive theme preferences in shared
  /// preferences.
  static const String prefKey = "adaptive_theme_preferences";

  /// Creates a new [ShadcnAdaptiveTheme] instance.
  const ShadcnAdaptiveTheme({
    super.key,
    required this.light,
    ThemeData? dark,
    required this.initial,
    required this.builder,
    this.debugShowFloatingThemeButton = false,
  }) : dark = dark ?? light;

  @override
  State<ShadcnAdaptiveTheme> createState() => _ShadcnAdaptiveThemeState();

  /// Returns the current adaptive theme manager for the given context.
  static AdaptiveThemeManager<ThemeData> of(BuildContext context) {
    context
        .dependOnInheritedWidgetOfExactType<
          InheritedAdaptiveTheme<ThemeData>
        >();
    return context.findAncestorStateOfType<State<ShadcnAdaptiveTheme>>()!
        as AdaptiveThemeManager<ThemeData>;
  }

  /// Returns the current adaptive theme manager for the given context,
  /// or `null` if no manager is found.
  static AdaptiveThemeManager<ThemeData>? maybeOf(BuildContext context) {
    context
        .dependOnInheritedWidgetOfExactType<
          InheritedAdaptiveTheme<ThemeData>
        >();
    final state = context.findAncestorStateOfType<State<ShadcnAdaptiveTheme>>();
    if (state == null) return null;
    return state as AdaptiveThemeManager<ThemeData>;
  }

  /// Returns the current adaptive theme mode for the given context.
  static Future<AdaptiveThemeMode?> getThemeMode() =>
      AdaptiveTheme.getThemeMode();
}

class _ShadcnAdaptiveThemeState extends State<ShadcnAdaptiveTheme>
    with WidgetsBindingObserver, AdaptiveThemeManager<ThemeData> {
  late bool _debugShowFloatingThemeButton = widget.debugShowFloatingThemeButton;

  @override
  bool get debugShowFloatingThemeButton => _debugShowFloatingThemeButton;

  @override
  void initState() {
    super.initState();
    initialize(
      light: widget.light,
      dark: widget.dark,
      initial: widget.initial,
      overrideMode: null,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mode.isSystem && mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant ShadcnAdaptiveTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.debugShowFloatingThemeButton !=
            oldWidget.debugShowFloatingThemeButton &&
        _debugShowFloatingThemeButton != widget.debugShowFloatingThemeButton) {
      _debugShowFloatingThemeButton = widget.debugShowFloatingThemeButton;
    }
  }

  @override
  bool get isDefault =>
      theme == widget.light && darkTheme == widget.dark && mode == defaultMode;

  @override
  Brightness get brightness => theme.brightness;

  @override
  Future<bool> reset() async {
    setTheme(light: widget.light, dark: widget.dark, notify: false);
    return super.reset();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedAdaptiveTheme<ThemeData>(
      manager: this,
      child: Builder(
        builder: (context) {
          final child = widget.builder(
            context,
            theme,
            mode.isLight ? theme : darkTheme,
          );

          if (!kReleaseMode && _debugShowFloatingThemeButton) {
            return DebugFloatingThemeButtonWrapper(
              manager: this,
              debugShow: true,
              child: child,
            );
          }

          return child;
        },
      ),
    );
  }

  @override
  void updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    modeChangeNotifier.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setDebugShowFloatingThemeButton(bool enabled) {
    _debugShowFloatingThemeButton = enabled;
    setState(() {});
  }
}
