// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:buzzer/ui/routes/home/home_screen.dart' as _i1;
import 'package:buzzer/ui/routes/ingame/ingame_screen.dart' as _i2;
import 'package:buzzer/ui/routes/license/license_screen.dart' as _i3;

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.IngameScreen]
class IngameRoute extends _i4.PageRouteInfo<void> {
  const IngameRoute({List<_i4.PageRouteInfo>? children})
    : super(IngameRoute.name, initialChildren: children);

  static const String name = 'IngameRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.IngameScreen();
    },
  );
}

/// generated route for
/// [_i3.LicenseScreen]
class LicenseRoute extends _i4.PageRouteInfo<void> {
  const LicenseRoute({List<_i4.PageRouteInfo>? children})
    : super(LicenseRoute.name, initialChildren: children);

  static const String name = 'LicenseRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.LicenseScreen();
    },
  );
}
