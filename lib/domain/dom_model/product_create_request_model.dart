

class ProductCreateRequestModel{
  final String name;
  final String description; // Fixed typo in variable name
  final bool isAvailable;

  ProductCreateRequestModel({required this.name,required this.description,required this.isAvailable});


  // Convert a Map to a ProductCreateRequestModel instance
  factory ProductCreateRequestModel.fromMap(Map<String, dynamic> map) {
    return ProductCreateRequestModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '', // Fixed key to match database schema
      isAvailable: (map['isAvailable'] ?? 0) == 1, // Convert int to bool
    );
  }

  // Convert a ProductCreateRequestModel instance to a Map
  Map<String, dynamic> toMap() {
    return {

      'name': name,
      'description': description, // Fixed key to match database schema
      'isAvailable': isAvailable ? 1 : 0, // Convert bool to int

    };
  }

}