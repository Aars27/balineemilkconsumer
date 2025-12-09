
class DailyOrder {
  final String id;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String deliveryTime;
  final String deliveryDate;
  final bool isActive;
  final String status; // 'delivered', 'pending', 'scheduled'

  DailyOrder({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.deliveryTime,
    required this.deliveryDate,
    this.isActive = true,
    this.status = 'scheduled',
  });
}
