class OrderHistoryResponse {
  final bool flag;
  final String message;
  final List<Order> orders;

  OrderHistoryResponse({
    required this.flag,
    required this.message,
    required this.orders,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      flag: json["flag"] ?? false,
      message: json["message"] ?? "",
      orders: (json["data"] as List)
          .map((e) => Order.fromJson(e))
          .toList(),
    );
  }
}

class Order {
  final String orderId;
  final String date;
  final String status;
  final String paymentStatus;
  final List<OrderItem> items;
  final double totalAmount;

  Order({
    required this.orderId,
    required this.date,
    required this.status,
    required this.paymentStatus,
    required this.items,
    required this.totalAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json["order_id"] ?? "",
      date: json["date"] ?? "",
      status: json["status"] ?? "",
      paymentStatus: json["payment_status"] ?? "",
      items: (json["items"] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      totalAmount: double.tryParse(json["total_amount"] ?? "0") ?? 0,
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double rate;
  final double amount;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.rate,
    required this.amount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json["product_name"] ?? "",
      quantity: int.tryParse(json["qty"] ?? "0") ?? 0,
      rate: double.tryParse(json["rate"] ?? "0") ?? 0,
      amount: double.tryParse(json["amount"] ?? "0") ?? 0,
    );
  }
}
