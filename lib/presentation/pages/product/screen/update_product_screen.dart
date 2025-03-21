import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/controller/product_controller.dart';
import '../../../../domain/dom_model/product_model.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final nameController=TextEditingController();
  final descriptionController=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Update Product"),
      ),
      body: GetBuilder<ProductController>(builder: (productController) {
        return productController.isUpdateProductLoading==false?SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text("Product Name: ${productController.selectedProduct!.name}"),
                const SizedBox(height: 20),
                Text("Product Description: ${productController.selectedProduct!.description}"),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Update  Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.production_quantity_limits),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Field
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Update Description",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note_alt_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: Text("Is Available"),
                  value: productController.selectedProduct!.isAvailable,
                  onChanged: (value) {
                    productController.topSelectedAvailable();
                  },
                ),
                const SizedBox(height: 40,),
                ElevatedButton(
                  onPressed: () {
                    ProductModel product = productController.selectedProduct!;
                    if(nameController.text.isNotEmpty){
                      product.name = nameController.text;
                    }
                    if(descriptionController.text.isNotEmpty){
                      product.description = descriptionController.text;
                    }
                    productController.updateProduct(product).then((value) {
                      if(productController.isUpdateProductLoading==false){
                        productController.removeSelectedProduct();
                        nameController.clear();
                        descriptionController.clear();
                        Navigator.pop(context);
                      }
                    },);
                  },
                  child: const Text("Update Product"),
                ),
              ],
            ),
          ),
        ):Center(child: CircularProgressIndicator());
      },),
    );
  }
}
