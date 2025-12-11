import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;

  const ProductListScreen({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: products.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) {
          final p = products[index];
          final img = p["image"];

          return ListTile(
            leading: Image.network(
              "https://balinee.pmmsapp.com/$img",
              width: 50,
              height: 50,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image),
            ),
            title: Text(p["name"]),
            subtitle: Text("₹${p["price"]}"),
          );
        },
      ),
    );
  }
}
