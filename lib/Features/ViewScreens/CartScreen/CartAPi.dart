import 'package:dio/dio.dart';
import '../../../Components/Savetoken/utils_local_storage.dart';
import 'CartModal.dart';
import 'orrdermodal.dart';

class CartApiService {
  late final Dio _dio;

  CartApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://balinee.pmmsapp.com/api",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage.getApiToken();
          print("🔑 Token: $token");
          print("🚀 API Call: ${options.method} ${options.baseUrl}${options.path}");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ Response Status: ${response.statusCode}");
          print("📥 Response Data: ${response.data}");
          handler.next(response);
        },
        onError: (error, handler) {
          print("❌ API Error: ${error.message}");
          print("📍 Error Response: ${error.response?.data}");
          handler.next(error);
        },
      ),
    );
  }

  // ================= GET CART =================
  Future<CartData?> getCart() async {
    try {
      print("\n📦 ========== GET CART ==========");
      final response = await _dio.get("/cart");

      print("🔍 Full Response: ${response.data}");
      print("🔍 Flag: ${response.data["flag"]}");

      if (response.data["flag"] == true && response.data["cart"] != null) {
        print("✅ Parsing cart data...");
        
        // ✅ FIX: response.data["cart"] ko parse karo, directly response.data ko nahi
        final cartData = CartData.fromJson(response.data["cart"]);
        
        print("✅ Cart Items Count: ${cartData.items.length}");
        print("✅ Subtotal: ${cartData.subtotal}");
        
        return cartData;
      } else {
        print("❌ Flag is false or cart is null");
      }
    } catch (e, stackTrace) {
      print("❌ CART GET ERROR: $e");
      print("📍 StackTrace: $stackTrace");
    }
    return null;
  }

  // ================= ADD ITEM =================
  Future<bool> addToCart(int productId, int qty) async {
    try {
      print("\n➕ ========== ADD TO CART ==========");
      print("📦 Product ID: $productId, Quantity: $qty");

      final response = await _dio.post(
        "/cart/add",
        data: {"product_id": productId, "quantity": qty},
      );

      print("🔍 Add Response: ${response.data}");
      print("🔍 Add Response Flag: ${response.data["flag"]}");
      
      return response.data["flag"] == true;
    } catch (e) {
      print("❌ ADD CART ERROR: $e");
      return false;
    }
  }

  // ================= UPDATE QTY (Not used, keeping for reference) =================
  Future<bool> updateCart(int cartItemId, int qty) async {
    try {
      print("\n🔄 ========== UPDATE CART ==========");
      print("📦 Cart Item ID: $cartItemId, New Quantity: $qty");

      final response = await _dio.post(
        "/cart/update",
        data: {"cart_item_id": cartItemId, "quantity": qty},
      );

      print("🔍 Update Response Flag: ${response.data["flag"]}");
      return response.data["flag"] == true;
    } catch (e) {
      print("❌ UPDATE CART ERROR: $e");
      return false;
    }
  }

  // ================= REMOVE ITEM =================
  Future<bool> removeFromCart(int cartItemId) async {
    try {
      print("\n🗑️ ========== REMOVE FROM CART ==========");
      print("📦 Cart Item ID: $cartItemId");

      final response = await _dio.post(
        "/cart/remove",
        data: {"cart_item_id": cartItemId},
      );

      print("🔍 Remove Response: ${response.data}");
      print("🔍 Remove Response Flag: ${response.data["flag"]}");
      
      return response.data["flag"] == true;
    } catch (e) {
      print("❌ REMOVE CART ERROR: $e");
      return false;
    }
  }

  // ================= ORDER SUMMARY =================
  Future<OrderSummary?> getSummary() async {
    try {
      print("\n💰 ========== GET ORDER SUMMARY ==========");
      final response = await _dio.get("/order-summary");

      print("🟢 FULL SUMMARY RESPONSE: ${response.data}");

      if (response.data["flag"] == true && response.data["data"] != null) {
        final summary = OrderSummary.fromJson(response.data["data"]);

        print("🟢 SUMMARY ITEMS COUNT: ${summary.items.length}");
        print("🟢 TOTAL AMOUNT: ${summary.totalAmount}");

        return summary;
      } else {
        print("⚠️ Summary flag is false or data is null");
      }
    } catch (e, stackTrace) {
      print("🔴 SUMMARY ERROR: $e");
      print("📍 StackTrace: $stackTrace");
    }
    return null;
  }

  // ================= CHECKOUT =================
  Future<bool> checkout({
    required String address,
    required int slot,
    required String paymentMethod,
    required double lat,
    required double lng,
  }) async {
    try {
      print("\n🧾 ========== CHECKOUT ==========");

      final response = await _dio.post(
        "/checkout",
        data: {
          "delivery_address": address,
          "delivery_slot": slot,
          "payment_method": paymentMethod,
          "lat": lat,
          "lng": lng,
        },
      );

      print("✅ Checkout Response: ${response.data}");
      return response.data["flag"] == true;
    } catch (e) {
      print("❌ CHECKOUT ERROR: $e");
      return false;
    }
  }
}