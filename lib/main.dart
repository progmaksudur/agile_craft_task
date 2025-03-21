import 'package:flutter/material.dart';
import 'package:agile_craft_task/di_container.dart' as di;
import 'package:get/get.dart';

import 'presentation/routes/app_pages.dart';
import 'presentation/routes/app_routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      navigatorKey:navigatorKey,
      initialRoute: RouteName.LOGIN_SCREEN,
      routes:RoutePages.pageBuilder,
      routingCallback: (route){
        debugPrint("======>${route!.current}");
      },
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class GetAppContext {
  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState? get navigator => navigatorKey.currentState;

}

