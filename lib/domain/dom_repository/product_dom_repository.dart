

import 'package:agile_craft_task/data/repository/response_model/base/api_response.dart';
import 'package:agile_craft_task/domain/dom_model/product_create_request_model.dart';

import '../dom_model/product_model.dart';

abstract  class ProductDomRepository{



  Future<ApiResponse> createProductOnline(ProductCreateRequestModel product);
  Future<void> createProductOffline(ProductCreateRequestModel product,bool isTemp);
  Future<void> addProductInLocal(ProductModel product);
  Future<void> updateProductInLocal(ProductModel product);
  Future<ApiResponse> updateProductOnline(ProductModel product);

  Future<ApiResponse> fetchProductFormOnline();
  Future<List<ProductModel>> getProductFormOffline();
  Future<List<Map<String, dynamic>>> getTempProductFormOffline();


  Future<void> removeTempProducts(int id);






}