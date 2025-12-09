

class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // 'delivered', 'pending', 'cancelled'

  Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.status,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
