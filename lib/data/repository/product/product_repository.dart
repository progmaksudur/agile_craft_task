


import 'package:agile_craft_task/domain/dom_model/product_create_request_model.dart';
import 'package:agile_craft_task/domain/dom_model/product_model.dart';
import 'package:agile_craft_task/domain/dom_repository/product_dom_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../const/api_endpoint.dart';
import '../../core/database/product_database.dart';
import '../../core/dio/dio_client.dart';
import '../../core/exceptions/api_error_handler.dart';
import '../response_model/base/api_response.dart';

class ProductRepository implements ProductDomRepository{

  final DioClient dioClient;
  final ProductDatabase productDatabase;


  ProductRepository({required this.dioClient,required this.productDatabase});

  @override
  Future<void> createProductOffline(ProductCreateRequestModel product,bool isTemp)async {
    // TODO: implement createProductOffline
    try{
      final productMap= product.toMap();
      productMap["isUpdate"]=0;
       await productDatabase.insertProduct(product.toMap(),isTemp: isTemp);

    }catch(error){
      if(kDebugMode){
        debugPrint(error.toString());
      }
      rethrow;
    }
  }

  @override
  Future<ApiResponse> createProductOnline(ProductCreateRequestModel product) async{

    final header = {
      "tenantId": "10",
    };
    final requestBody = {
      "name": product.name,
      "description": product.description,
      "isAvailable": product.isAvailable,
    };
    try{
      final response= await dioClient.post(ApiUrls.createProduct,data: requestBody,options: Options(
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
  Future<ApiResponse> fetchProductFormOnline() async{
    // TODO: implement fetchProductFormOnline
    try{
      final header = {
        "Abp.TenantId": "10",
      };
      final response= await dioClient.get(ApiUrls.getAllProducts,options: Options(
        headers: header
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
  Future<List<ProductModel>> getProductFormOffline()async {
    // TODO: implement getProductFormOffline
    try{
     final products = await productDatabase.fetchProducts(isTemp: false);
     return products.map((product) =>ProductModel.fromMap(product)).toList();
    }catch(error){
      if(kDebugMode){
        debugPrint(error.toString());
      }
      rethrow;
    }
  }

  @override
  Future<void> removeTempProducts(int id) async{
    // TODO: implement removeTempProducts
    try{
      return await productDatabase.clearTempProductById(id);
    }catch(error){
      if(kDebugMode){
        debugPrint(error.toString());
      }
      rethrow;
    }
  }

  @override
  Future<void> addProductInLocal(ProductModel product) async{
    // TODO: implement addProductInLocal
    try{
      await productDatabase.insertProduct(product.toMap(),isTemp: false);
    }catch(error){
      if(kDebugMode){
        debugPrint(error.toString());
      }
      rethrow;
    }
  }
  @override
  Future<void> updateProductInLocal(ProductModel product) async {
    // TODO: implement updateProductInLocal
    try{
      final productMap= {
        "id":product.id,
        "name":product.name,
        "description":product.description,
        "isAvailable":product.isAvailable ? 1 : 0,
        "isUpdate" : 1
      };

      await productDatabase.insertProduct(productMap,isTemp: true);

    }catch(error){
      if(kDebugMode){
        debugPrint(error.toString());
      }
      rethrow;
    }
  }

  @override
  Future<ApiResponse> updateProductOnline(ProductModel product)async {
    // TODO: implement updateProductOnline
    final header = {
      "tenantId": "10",
    };
    final requestBody = {
      "id" : product.id,
      "name": product.name,
      "description": product.description,
      "isAvailable": product.isAvailable,
    };
    try{
      final response= await dioClient.patch(ApiUrls.createProduct,data: requestBody,options: Options(
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
  Future<List<Map<String, dynamic>>> getTempProductFormOffline()async {
    // TODO: implement getTempProductFormOffline
    try{
      return await productDatabase.fetchProducts(isTemp: true);
    }catch(error){
      if(kDebugMode){
        debugPrint(error.toString());
      }
      rethrow;
    }
  }






}