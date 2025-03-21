


import 'package:agile_craft_task/presentation/pages/authentication/screen/login_screen.dart';
import 'package:agile_craft_task/presentation/pages/product/screen/update_product_screen.dart';

import '../pages/home/screen/home_screen.dart';
import '../pages/product/screen/create_product_screen.dart';
import 'app_routes.dart';

abstract class RoutePages{

  static final  pageBuilder={
    RouteName.HOME_SCREEN:(context) =>const HomeScreen(),
    RouteName.LOGIN_SCREEN:(context) =>const LoginScreen(),
    RouteName.CREATE_PRODUCT_SCREEN:(context) =>const CreateProductScreen(),
    RouteName.UPDATE_PRODUCT_SCREEN:(context) =>const UpdateProductScreen(),

  };





}

