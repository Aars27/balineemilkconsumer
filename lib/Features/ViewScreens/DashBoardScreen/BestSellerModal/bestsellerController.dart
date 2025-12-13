// lib/Features/ViewScreens/Products/ProductController.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../../../Components/Savetoken/utils_local_storage.dart';
import '../ProductListscreen/ProductModal.dart';


class ProductController extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  String _currentUserType = 'Consumer';
  final Dio _dio = Dio();

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

      final url = 'https://balinee.pmmsapp.com/api/product-list/$categoryId';

      print("📡 API URL: $url");
      print("🔑 Token: ${token.substring(0, 30)}...");

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final responseData = response.data;
        final productResponse = ProductListResponse.fromJson(responseData);

        if (productResponse.flag) {
          _products = productResponse.products;
          print("✅ Successfully loaded ${_products.length} products");
          _hasError = false;
        } else {
          _hasError = true;
          _errorMessage = "Failed to load products";
          print("❌ API returned flag: false");
        }
      }
    } on DioException catch (e) {
      print("❌ Dio Exception: ${e.type}");
      print("Error Message: ${e.message}");
      print("Response: ${e.response?.data}");

      if (e.response?.statusCode == 401) {
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
        _errorMessage = e.response?.data['message'] ??
            "Failed to load products (${e.response?.statusCode ?? 'Network Error'})";
        print("❌ Error: ${e.response?.statusCode}");
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

      final url = 'https://balinee.pmmsapp.com/api/cart/add';
      final requestBody = {
        'product_id': productId,
        'quantity': quantity,
      };

      print("📡 API URL: $url");
      print("📤 Request Body: $requestBody");

      final response = await _dio.post(
        url,
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final responseData = response.data;
        final cartResponse = AddToCartResponse.fromJson(responseData);

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
      }
      return false;
    } on DioException catch (e) {
      print("❌ Dio Exception: ${e.type}");
      print("Error Message: ${e.message}");
      print("Response: ${e.response?.data}");

      if (e.response?.statusCode == 401) {
        print("❌ Unauthorized - Token expired");

        // Clear storage and redirect to login
        await LocalStorage.clearAll();
        if (context.mounted) {
          context.go('/loginpage');
        }
        return false;
      } else {
        print("❌ Error: ${e.response?.statusCode}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  e.response?.data['message'] ??
                      "Failed to add to cart (${e.response?.statusCode ?? 'Network Error'})"
              ),
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