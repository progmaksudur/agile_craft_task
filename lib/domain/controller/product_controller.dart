

import 'dart:async';

import 'package:agile_craft_task/data/core/network/network_info_services.dart';
import 'package:agile_craft_task/domain/dom_model/product_create_request_model.dart';
import 'package:agile_craft_task/domain/dom_repository/product_dom_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/repository/response_model/base/api_response.dart';
import '../dom_model/product_model.dart';

class ProductController extends GetxController{

  final ProductDomRepository repository;
  final DeviceNetworkInfo deviceNetworkInfo;

  ProductController({required this.repository,required this.deviceNetworkInfo});

  late StreamSubscription<bool> _connectivitySubscription;


  void startListeningToConnectivity() {
    _connectivitySubscription = deviceNetworkInfo.onConnectivityChanged.listen(
          (bool isConnected) async {
            if (isConnected) {
              await syncOfflineProducts();
            }
      },
    );
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;



  bool _createProductLoading=false;
  bool get createProductLoading=>_createProductLoading;

  Future<void> createProduct(String name,String description,bool isAvailable)async{
    _createProductLoading=true;
    update();
    final checkConnection= await deviceNetworkInfo.isConnected();
    final product = ProductCreateRequestModel(
        name: name,
        description: description,
        isAvailable: isAvailable);

    if (checkConnection==true) {
        try {
          await repository.createProductOnline(product);
        } catch (error) {
          await repository.createProductOffline(product, true);
          if (kDebugMode) {
            debugPrint("Failed to sync online, stored offline: ${product.name}");
          }
      }
    } else {
      await repository.createProductOffline(product, true);
      if (kDebugMode) {
        debugPrint("No internet. Stored products offline.");
      }
    }
    getAllProductFromOnlineAndOffline();
    _createProductLoading=false;
    update();
  }

  Future<void> syncOfflineProducts() async {
    final checkConnection= await deviceNetworkInfo.isConnected();
    if (checkConnection) {
      final offlineProducts = await repository.getTempProductFormOffline();
      if(offlineProducts.isNotEmpty){
        for (var product in offlineProducts) {

          try {
            if(product['isUpdate']==1){
              final productMap={
                "name": product['name'],
                "description": product['description'],
                "isAvailable": product['isAvailable'],
                "id": product['id'],
              };
              await repository.updateProductOnline(ProductModel.fromMap(productMap));
            }else{
              final productMap={
                "name": product['name'],
                "description": product['description'],
                "isAvailable": product['isAvailable'],
              };
              final productRequest = ProductCreateRequestModel.fromMap(productMap);
              await repository.createProductOnline(productRequest);
            }

            await repository.removeTempProducts(product['id']);
          } catch (error) {
            if (kDebugMode) {
              debugPrint("Sync failed for ${product['name']}");
            }
          }
        }

        getAllProductFromOnlineAndOffline();
      }

    }
  }

  bool _isProductLoading=false;
  bool get isProductLoading=>_isProductLoading;


  Future<void> getAllProductFromOnlineAndOffline() async {
    _isProductLoading=true;
    update();
    List<ProductModel> allProducts = [];
    Set<int> productIds = {};
    try {
      bool isConnected = await deviceNetworkInfo.isConnected();
      if (isConnected) {
        // Fetch from online API
        ApiResponse apiResponse = await repository.fetchProductFormOnline();
        if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
          List<ProductModel> onlineProducts = (apiResponse.response?.data as List)
              .map((e) => ProductModel.fromMap(e))
              .toList();
          for (var product in onlineProducts) {
            if (!productIds.contains(product.id)) {
              productIds.add(product.id);
              allProducts.add(product);
              await repository.addProductInLocal(product);
            }
          }
        }
      }
      // Fetch from local database
      List<ProductModel> offlineProducts =
      await repository.getProductFormOffline();


      // Add unique offline products
      for (var product in offlineProducts) {
        if (!productIds.contains(product.id)) {
          productIds.add(product.id);
          allProducts.add(product);
        }
      }

      final tempProducts = await repository.getTempProductFormOffline();
      ///product id not checking
      for(var product in tempProducts) {
        final productMap = {
          "name": product['name'],
          "description": product['description'],
          "isAvailable": product['isAvailable'],
          "id": product['id'],
        };
        allProducts.add(ProductModel.fromMap(productMap));
      }

    } catch (error) {
      if (kDebugMode) {
        debugPrint("Error fetching products: $error");
      }
    }
    _isProductLoading=false;
    _products = allProducts;
    update();
  }


  ProductModel? _selectedProduct;
  ProductModel? get selectedProduct => _selectedProduct;

  void setSelectedProduct(ProductModel product) {
    _selectedProduct = product;
    update();
  }
  void removeSelectedProduct() {
    _selectedProduct = null;
    update();
  }
  void topSelectedAvailable() {
    _selectedProduct?.isAvailable = !_selectedProduct!.isAvailable;
    update();
  }

  bool _isUpdateProductLoading=false;
  bool get isUpdateProductLoading=>_isUpdateProductLoading;

  Future<void> updateProduct(ProductModel product)async{
    _isUpdateProductLoading=true;
    update();

    final checkConnection= await deviceNetworkInfo.isConnected();
    if (checkConnection==true) {
      try {
        await repository.updateProductOnline(product);
      } catch (error) {
        await repository.updateProductInLocal(product);
        if (kDebugMode) {
          debugPrint("Failed to sync online, stored offline: ${product.name}");
        }
      }
    }else{
      await repository.updateProductInLocal(product);
      if (kDebugMode) {
        debugPrint("No internet.Update data stored  offline.");
      }
    }
    _isUpdateProductLoading=false;
    update();

  }




}