
// // Cart Item Card Widget
// import 'package:consumerbalinee/Features/ViewScreens/CartScreen/CartController.dart';
// import 'package:consumerbalinee/Features/ViewScreens/CartScreen/CartModal.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CartItemCard extends StatelessWidget {
//   final CartItem item;

//   const CartItemCard({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Product Image
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF8F9FA),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(
//               child: Image.asset(
//                 item.productImage,
//                 height: 60,
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Icon(
//                     Icons.local_drink,
//                     size: 50,
//                     color: const Color(0xFF4A90E2),
//                   );
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),

//           // Product Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.productName,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   item.unit,
//                   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '₹${item.price.toStringAsFixed(0)}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF4A90E2),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Quantity Controls
//           Column(
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       context.read<CartController>().decreaseQuantity(item.id);
//                     },
//                     child: Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(
//                         Icons.remove,
//                         size: 18,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       item.quantity.toString(),
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       context.read<CartController>().increaseQuantity(item.id);
//                     },
//                     child: Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF4A90E2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(
//                         Icons.add,
//                         size: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: () {
//                   context.read<CartController>().removeItem(item.id);
//                 },
//                 child: Icon(
//                   Icons.delete_outline,
//                   size: 20,
//                   color: Colors.red[400],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
