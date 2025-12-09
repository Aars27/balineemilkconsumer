// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'ControllerDashboard.dart';
// import 'ModalDashboard.dart';
//
// class ProductCard extends StatelessWidget {
//   final Product product;
//   const ProductCard({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     final img = "https://balinee.pmmsapp.com/${product.image}";
//
//     return Container(
//       width: 150,
//       margin: const EdgeInsets.only(right: 12),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         children: [
//           Image.network(
//             img,
//             height: 70,
//             errorBuilder: (_, __, ___) => const Icon(Icons.local_drink, size: 40),
//           ),
//           const SizedBox(height: 10),
//
//           Text(product.name,
//               style:
//               const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
//           Text("₹${product.price}",
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//
//           const SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {
//               Provider.of<DashboardController>(context, listen: false)
//                   .addToCart(product);
//             },
//             child: const Text("Add"),
//           )
//         ],
//       ),
//     );
//   }
// }
