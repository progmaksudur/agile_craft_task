

import 'package:agile_craft_task/data/repository/response_model/base/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../domain/dom_repository/auth_dom_repository.dart';
import '../../const/api_endpoint.dart';
import '../../core/dio/dio_client.dart';
import '../../core/exceptions/api_error_handler.dart';
import '../../core/local_storage/local_storage_service.dart';

class AuthRepository implements AuthDomRepository{

  final DioClient dioClient;
  final LocalStorageServices localStorageServices;


  AuthRepository({required this.dioClient,required this.localStorageServices});

  @override
  Future<ApiResponse> login(String emailOrPhone, String password)async {
    // TODO: implement login
    final rowData={
      "userNameOrEmailAddress":emailOrPhone,
      "password":password,
    };
    final header = {
      "Abp.TenantId": "10",
    };
    try{
      final response= await dioClient.post(ApiUrls.authentication,data: rowData,options: Options(
        headers: header,
      ));
      return ApiResponse.withSuccess(response);
    }catch(error){
      if(kDebugMode){
        debugPrint(error.toString());
      }
      return ApiResponse.withError(ApiErrorHandler.getMessage(error));
    }


  }

  @override
  Future<String> getUserTokenFromLocal() {
    // TODO: implement getUserTokenFromLocal
    return localStorageServices.getUserToken();
  }

  @override
  Future<void> removeUserToken() {
    // TODO: implement removeUserToken
    return localStorageServices.removeUserToken();
  }

  @override
  Future<void> saveUserToken(String tokenData)async{
    // TODO: implement saveUserToken
    return await localStorageServices.saveUserToken(tokenData).then((value) => dioClient.updateHeader(localStorageServices.getUserToken()));

  }

}