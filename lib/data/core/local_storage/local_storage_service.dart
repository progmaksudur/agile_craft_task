import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/api_endpoint.dart';





class LocalStorageServices{
  final SharedPreferences sharedPreferences;

  LocalStorageServices({required this.sharedPreferences});


  ///User Token
  Future<void> saveUserToken(String token) async {
    try {
      await sharedPreferences.setString(ApiUrls.userToken, token);
      if(kDebugMode){
        print("========>User Token Stored<=======");
        print(await sharedPreferences.getString(ApiUrls.userToken));
      }
    } catch (e) {
      throw e;
    }
  }

  //Get  token in local storage
  getUserToken() {
    SharedPreferences.getInstance();
    return sharedPreferences.getString(ApiUrls.userToken) ?? "";
  }
  // remove  token from local storage
  removeUserToken() async{
    await SharedPreferences.getInstance();
    return sharedPreferences.remove(ApiUrls.userToken);
  }




}