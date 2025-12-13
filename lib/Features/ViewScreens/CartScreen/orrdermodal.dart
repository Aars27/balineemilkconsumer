class OrderSummary {
  final List<SummaryItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double totalAmount;

  OrderSummary({
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.discount,
    required this.totalAmount,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      items: (json['items'] as List)
          .map((e) => SummaryItem.fromJson(e))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryCharge: (json['delivery_charge'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
    );
  }
}

class SummaryItem {
  final int productId;
  final String productName;
  final int qty;
  final double rate;
  final double amount;

  SummaryItem({
    required this.productId,
    required this.productName,
    required this.qty,
    required this.rate,
    required this.amount,
  });

  factory SummaryItem.fromJson(Map<String, dynamic> json) {
    return SummaryItem(
      productId: json['product_id'],
      productName: json['product_name'],
      qty: json['qty'],
      rate: (json['rate'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
