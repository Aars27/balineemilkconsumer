
class CartItem {
  final String id;
  final String productName;
  final String productImage;
  final double price;
  int quantity;
  final String unit;
  final String category;

  CartItem({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.category,
  });

  double get totalPrice => price * quantity;
}