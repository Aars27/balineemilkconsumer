class BestSellerModel {
  final int productId;
  final String name;
  final String image;
  final String price;
  final int totalSold;

  BestSellerModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.totalSold,
  });

  factory BestSellerModel.fromJson(Map<String, dynamic> json) {
    return BestSellerModel(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? "0",
      totalSold: json['total_sold'] ?? 0,
    );
  }
}
