import 'package:agile_craft_task/domain/controller/product_controller.dart';
import 'package:agile_craft_task/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final productController=Get.find<ProductController>();
    productController.getAllProductFromOnlineAndOffline();
    productController.startListeningToConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),

            onPressed: () {
              Get.find<ProductController>().getAllProductFromOnlineAndOffline();
            },
          ),
        ],
      ),
      body: GetBuilder<ProductController>(
        builder: (productController) {
          final products = productController.products;

          return productController.isProductLoading == false
              ? ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: ListTile(
                      onTap: (){
                        productController.setSelectedProduct(products[index]);
                        Navigator.pushNamed(context, RouteName.UPDATE_PRODUCT_SCREEN);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.purple, width: 1),
                      ),
                      title: Text(products[index].name),
                      subtitle: Text(products[index].description),
                      trailing: Text(products[index].isAvailable.toString()),
                    ),
                  );
                },
              )
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.CREATE_PRODUCT_SCREEN);
        },
        child: Icon(Icons.add),
    ),
    );
  }
}
