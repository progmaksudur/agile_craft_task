


import 'dart:async';

import 'package:agile_craft_task/data/repository/product/product_repository.dart';
import 'package:agile_craft_task/domain/controller/product_controller.dart';
import 'package:agile_craft_task/domain/dom_repository/product_dom_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/const/api_endpoint.dart';
import 'data/core/database/product_database.dart';
import 'data/core/dio/dio_client.dart';
import 'data/core/dio/logging_interceptor.dart';
import 'data/core/local_storage/local_storage_service.dart';
import 'data/core/network/network_info_services.dart';
import 'data/repository/product/auth_repository.dart';
import 'domain/controller/auth_controller.dart';
import 'domain/dom_repository/auth_dom_repository.dart';





Future<void> init() async {
  
  ///Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => Dio());
  Get.lazyPut(() => LoggingInterceptor());
  Get.lazyPut(() => Connectivity());



  //Services
  Get.lazyPut(()=>DioClient(ApiUrls.baseUrl, Get.find<Dio>(), loggingInterceptor: Get.find<LoggingInterceptor>(), sharedPreferences: Get.find<SharedPreferences>()));
  Get.lazyPut(() => LocalStorageServices(sharedPreferences: Get.find()));
  Get.lazyPut(() => DeviceNetworkInfo(connectivity: Get.find<Connectivity>()));
  final productDatabase = await ProductDatabase.instance.database;
  Get.put<ProductDatabase>(ProductDatabase.instance);


  //Repositories
     Get.lazyPut<ProductDomRepository>(() => ProductRepository(dioClient: Get.find(),productDatabase: Get.find()));
     Get.lazyPut<AuthDomRepository>(() => AuthRepository(dioClient: Get.find(),localStorageServices: Get.find()));


  // //Controller
      Get.put<AuthController>(AuthController(repository: Get.find()));
      Get.put<ProductController>(ProductController(repository: Get.find(),deviceNetworkInfo: Get.find()));
  //



}

