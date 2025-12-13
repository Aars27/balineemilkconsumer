// lib/Features/ViewScreens/Products/ProductModel.dart

class ProductModel {
  final int id;
  final int categoryId;
  final String? milkType;
  final String name;
  final String consumerRate;
  final String retailerRate;
  final String wholesalerRate;
  final String image;
  final String description;
  final String qty;
  final String unit;
  final int isActive;

  ProductModel({
    required this.id,
    required this.categoryId,
    this.milkType,
    required this.name,
    required this.consumerRate,
    required this.retailerRate,
    required this.wholesalerRate,
    required this.image,
    required this.description,
    required this.qty,
    required this.unit,
    required this.isActive,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      milkType: json['milk_type'],
      name: json['name'] ?? '',
      consumerRate: json['consumer_rate']?.toString() ?? '0',
      retailerRate: json['retailer_rate']?.toString() ?? '0',
      wholesalerRate: json['wholesaler_rate']?.toString() ?? '0',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      qty: json['qty']?.toString() ?? '0',
      unit: json['unit'] ?? '',
      isActive: json['is_active'] ?? 1,
    );
  }

  // Get price based on user type
  String getPriceForUserType(String? userType) {
    if (userType == null) return consumerRate;

    switch (userType.toLowerCase()) {
      case 'consumer':
        return consumerRate;
      case 'retailer':
        return retailerRate;
      case 'wholesaler':
        return wholesalerRate;
      default:
        return consumerRate;
    }
  }
}

class ProductListResponse {
  final bool flag;
  final List<ProductModel> products;

  ProductListResponse({
    required this.flag,
    required this.products,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      flag: json['flag'] ?? false,
      products: (json['data'] as List?)
          ?.map((item) => ProductModel.fromJson(item))
          .toList() ?? [],
    );
  }
}

class AddToCartRequest {
  final int productId;
  final int quantity;

  AddToCartRequest({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }
}

class AddToCartResponse {
  final bool flag;
  final String message;

  AddToCartResponse({
    required this.flag,
    required this.message,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      flag: json['flag'] ?? false,
      message: json['message'] ?? '',
    );
  }
}