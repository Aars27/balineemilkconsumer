import 'package:flutter/material.dart';

import 'CategoryModal/CategoryModal.dart';
import 'ModalDashboard.dart';
import 'ProductListscreen/ProductList.dart';

// Replace the existing CategoryCard class at the bottom of DashboardView.dart with this:

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.image != null
        ? "https://balinee.pmmsapp.com/${category.image}"
        : null;

    return GestureDetector(
      onTap: () {
        print("🔄 Navigating to products for category: ${category.name}");

        // Navigate to Product List Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(category: category),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                print("❌ Category image error for ${category.name}: $error");
                return const Icon(Icons.category, size: 32, color: Colors.grey);
              },
            )
                : const Icon(Icons.category, size: 32, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}