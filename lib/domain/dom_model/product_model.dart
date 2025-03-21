class ProductModel {
  int id;
  String name;
  String description; // Fixed typo in variable name
  bool isAvailable;
  int tenantId;



  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isAvailable,
    required this.tenantId,
  });



  // Convert a Map to a ProductTempModel instance
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '', // Fixed key to match database schema
      isAvailable: (map['isAvailable'] ?? 0) == 1, // Convert int to bool
      tenantId: map['tenantId'] ?? 0,
    );
  }

  // Convert a ProductTempModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description, // Fixed key to match database schema
      'isAvailable': isAvailable ? 1 : 0, // Convert bool to int
      'tenantId': tenantId,
    };
  }
}
