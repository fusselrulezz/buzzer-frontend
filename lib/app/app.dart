import 'package:buzzer/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:buzzer/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:buzzer/ui/views/home/home_view.dart';
import 'package:buzzer/ui/views/startup/startup_view.dart';
import 'package:buzzer/ui/views/unknown/unknown_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:buzzer/services/system_config_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    CustomRoute(page: StartupView, initial: true),
    CustomRoute(page: HomeView),

    // @stacked-route
    CustomRoute(page: UnknownView, path: '/404'),

    /// When none of the above routes match, redirect to UnknownView
    RedirectRoute(path: '*', redirectTo: '/404'),
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: RouterService),
    LazySingleton(classType: SystemConfigService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
