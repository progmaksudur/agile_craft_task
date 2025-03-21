import 'package:agile_craft_task/data/repository/response_model/base/api_response.dart';

abstract class AuthDomRepository{



  Future<ApiResponse> login(String emailOrPassword,String password);

  Future<void> saveUserToken(String tokenData);
  Future<void> removeUserToken();
  Future<String> getUserTokenFromLocal();



}