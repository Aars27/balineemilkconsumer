class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String unit;
  final bool isBestSeller;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.unit,
    this.isBestSeller = false,
  });

  // From JSON - for API integration
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      isBestSeller: json['is_best_seller'] ?? false,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  // From JSON - for API integration
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class BannerModel {
  final String id;
  final String image;
  final String title;
  final String subtitle;

  BannerModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  // From JSON - for API integration
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toString() ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }
}