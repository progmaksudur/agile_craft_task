import 'package:agile_craft_task/domain/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {

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
        title: Text("Create Product"),
        centerTitle: true,
      ),
      body: GetBuilder<ProductController>(builder: (productController) {
        return productController.createProductLoading==false?SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.production_quantity_limits),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Field
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note_alt_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    productController.createProduct(nameController.text,
                        descriptionController.text,
                        false).then((value) {
                          if(productController.createProductLoading==false){
                            nameController.clear();
                            descriptionController.clear();
                            Navigator.pop(context);
                          }
                        },);
                  },
                  child: const Text("Create Product"),
                ),
              ],
            ),
          ),
        ):Center(child: CircularProgressIndicator());
      },),
    );
  }
}
