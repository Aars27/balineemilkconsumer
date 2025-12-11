class DailyOrder {
  final int id;
  final String productName;
  final String image;
  final String unit;
  final double price;
  final int totalQty;
  final int totalOrders;

  bool isActive; // For Pause/Resume Button

  DailyOrder({
    required this.id,
    required this.productName,
    required this.image,
    required this.unit,
    required this.price,
    required this.totalQty,
    required this.totalOrders,
    this.isActive = true,
  });

  factory DailyOrder.fromJson(Map<String, dynamic> json) {
    return DailyOrder(
      id: json["product_id"],
      productName: json["product_name"],
      image: json["image"] ?? "",
      unit: json["unit"] ?? "",
      price: (json["final_rate"] ?? 0).toDouble(),
      totalOrders: json["total_orders"] ?? 0,
      totalQty: json["total_qty"] ?? 0,
      isActive: true,
    );
  }
}
