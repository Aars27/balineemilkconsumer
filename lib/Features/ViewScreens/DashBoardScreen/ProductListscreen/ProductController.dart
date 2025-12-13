// lib/Features/ViewScreens/Products/ProductController.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../../../Components/Savetoken/utils_local_storage.dart';
import 'ProductModal.dart';


class ProductController extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  String _currentUserType = 'Consumer';

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  String get currentUserType => _currentUserType;

  // Load products by category
  Future<void> loadProductsByCategory(int categoryId, BuildContext context) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      print("\n🔄 LOADING PRODUCTS FOR CATEGORY: $categoryId");

      // Get token and user data
      final token = await LocalStorage.getApiToken();
      final userData = await LocalStorage.getUserData();

      if (token == null || token.isEmpty) {
        throw Exception("No authentication token found");
      }

      _currentUserType = userData?.userType ?? 'Consumer';
      print("👤 Current User Type: $_currentUserType");

      final url = Uri.parse('https://balinee.pmmsapp.com/api/product-list/$categoryId');

      print("📡 API URL: $url");
      print("🔑 Token: ${token.substring(0, 30)}...");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final productResponse = ProductListResponse.fromJson(jsonData);

        if (productResponse.flag) {
          _products = productResponse.products;
          print("✅ Successfully loaded ${_products.length} products");
          _hasError = false;
        } else {
          _hasError = true;
          _errorMessage = "Failed to load products";
          print("❌ API returned flag: false");
        }
      } else if (response.statusCode == 401) {
        _hasError = true;
        _errorMessage = "Session expired. Please login again.";
        print("❌ Unauthorized - Token expired");

        // Clear storage and redirect to login
        await LocalStorage.clearAll();
        if (context.mounted) {
          context.go('/loginpage');
        }
      } else {
        _hasError = true;
        _errorMessage = "Failed to load products (${response.statusCode})";
        print("❌ Error: ${response.statusCode}");
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = "Network error: ${e.toString()}";
      print("❌ Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to cart
  Future<bool> addToCart(int productId, int quantity, BuildContext context) async {
    try {
      print("\n🛒 ADDING TO CART");
      print("Product ID: $productId");
      print("Quantity: $quantity");

      final token = await LocalStorage.getApiToken();

      if (token == null || token.isEmpty) {
        throw Exception("No authentication token found");
      }

      final url = Uri.parse('https://balinee.pmmsapp.com/api/cart/add');
      final requestBody = AddToCartRequest(
        productId: productId,
        quantity: quantity,
      );

      print("📡 API URL: $url");
      print("📤 Request Body: ${jsonEncode(requestBody.toJson())}");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody.toJson()),
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final cartResponse = AddToCartResponse.fromJson(jsonData);

        if (cartResponse.flag) {
          print("✅ Successfully added to cart");

          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(cartResponse.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          return true;
        } else {
          print("❌ Failed to add to cart");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(cartResponse.message),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          return false;
        }
      } else if (response.statusCode == 401) {
        print("❌ Unauthorized - Token expired");

        // Clear storage and redirect to login
        await LocalStorage.clearAll();
        if (context.mounted) {
          context.go('/loginpage');
        }
        return false;
      } else {
        print("❌ Error: ${response.statusCode}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to add to cart (${response.statusCode})"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return false;
      }
    } catch (e) {
      print("❌ Exception: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network error: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return false;
    }
  }

  // Clear products
  void clearProducts() {
    _products = [];
    notifyListeners();
  }
}