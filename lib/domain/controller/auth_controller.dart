

import 'package:agile_craft_task/data/repository/response_model/auth_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/repository/response_model/base/api_response.dart';
import '../../main.dart';
import '../../presentation/common_widgets/app_custom_snackbars.dart';
import '../dom_repository/auth_dom_repository.dart';

class AuthController extends GetxController{

  final AuthDomRepository repository;

  AuthController({required this.repository});


  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    update();
  }

  ///User Log in methode
  bool _userSignInLoading=false;
  bool get userSignInLoading=>_userSignInLoading;
  Future<bool> userSignIn(String emailOrPassword,String password)async{
    _userSignInLoading=true;
    update();
    ApiResponse apiResponse = await repository.login(emailOrPassword, password);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _userSignInLoading=false;
      final logInModel=AuthResponse.fromJson(apiResponse.response!.data);
      update();
      if(logInModel.success==true){
        await repository.saveUserToken(logInModel.result!.accessToken.toString());
         appGreenSnackBar("Log in Successfully", GetAppContext.context!);
        return true;
      }else{
        _userSignInLoading=false;
        update();
         appErrorSnackBar(logInModel.error["message"], GetAppContext.context!);
        return false;
      }
    } else {
      debugPrint(apiResponse.error.toString());
      _userSignInLoading=false;
      update();
       appErrorSnackBar(apiResponse.error.toString(), GetAppContext.context!);
      return false;
    }
  }

  checkUserLogIn(){
    return repository.getUserTokenFromLocal() ==""?false:true;
  }

}