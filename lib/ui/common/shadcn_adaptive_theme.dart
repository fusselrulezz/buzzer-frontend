import "package:adaptive_theme/adaptive_theme.dart";
import "package:flutter/foundation.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

typedef ShadcnAdaptiveThemeBuilder =
    Widget Function(BuildContext context, ThemeData light, ThemeData dark);

class ShadcnAdaptiveTheme extends StatefulWidget {
  final ThemeData light;

  final ThemeData dark;

  final AdaptiveThemeMode initial;

  final ShadcnAdaptiveThemeBuilder builder;

  final bool debugShowFloatingThemeButton;

  static const String prefKey = "adaptive_theme_preferences";

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

  static AdaptiveThemeManager<ThemeData> of(BuildContext context) {
    context
        .dependOnInheritedWidgetOfExactType<
          InheritedAdaptiveTheme<ThemeData>
        >();
    return context.findAncestorStateOfType<State<ShadcnAdaptiveTheme>>()!
        as AdaptiveThemeManager<ThemeData>;
  }

  static AdaptiveThemeManager<ThemeData>? maybeOf(BuildContext context) {
    context
        .dependOnInheritedWidgetOfExactType<
          InheritedAdaptiveTheme<ThemeData>
        >();
    final state = context.findAncestorStateOfType<State<ShadcnAdaptiveTheme>>();
    if (state == null) return null;
    return state as AdaptiveThemeManager<ThemeData>;
  }

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
