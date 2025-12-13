class CartData {
  final int id;
  final double subtotal;
  final double deliveryCharge;
  final double total;
  final List<CartItem> items;

  CartData({
    required this.id,
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
    required this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'],
      subtotal: double.parse(json['subtotal']),
      deliveryCharge: double.parse(json['delivery_charge']),
      total: double.parse(json['total']),
      items: (json['items'] as List)
          .map((e) => CartItem.fromJson(e))
          .toList(),
    );
  }
}

class CartItem {
  final int id;
  final int quantity;
  final double price;
  final double total;
  final Product product;

  CartItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.total,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      price: double.parse(json['price']),
      total: double.parse(json['total']),
      product: Product.fromJson(json['product']),
    );
  }


CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      quantity: quantity ?? this.quantity,
      price: price,
      total: price * (quantity ?? this.quantity),
      product: product,
    );
  }












  /// 👇 UI helper getters
  String get productName => product.name;
  String get unit => "${product.qty} ${product.unit}";
  String get productImage =>
      "https://balinee.pmmsapp.com/${product.image}";
}

class Product {
  final int id;
  final String name;
  final String image;
  final String qty;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.qty,
    required this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      qty: json['qty'],
      unit: json['unit'],
    );
  }
}
