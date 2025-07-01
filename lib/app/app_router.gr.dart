// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:buzzer/model/game_context.dart' as _i5;
import 'package:buzzer/ui/routes/home/home_screen.dart' as _i1;
import 'package:buzzer/ui/routes/ingame/ingame_screen.dart' as _i2;
import 'package:flutter/material.dart' as _i4;

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i3.PageRouteInfo<void> {
  const HomeRoute({List<_i3.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.IngameScreen]
class IngameRoute extends _i3.PageRouteInfo<IngameRouteArgs> {
  IngameRoute({
    _i4.Key? key,
    required _i5.GameContext gameContext,
    List<_i3.PageRouteInfo>? children,
  }) : super(
         IngameRoute.name,
         args: IngameRouteArgs(key: key, gameContext: gameContext),
         initialChildren: children,
       );

  static const String name = 'IngameRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IngameRouteArgs>();
      return _i2.IngameScreen(key: args.key, gameContext: args.gameContext);
    },
  );
}

class IngameRouteArgs {
  const IngameRouteArgs({this.key, required this.gameContext});

  final _i4.Key? key;

  final _i5.GameContext gameContext;

  @override
  String toString() {
    return 'IngameRouteArgs{key: $key, gameContext: $gameContext}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IngameRouteArgs) return false;
    return key == other.key && gameContext == other.gameContext;
  }

  @override
  int get hashCode => key.hashCode ^ gameContext.hashCode;
}
