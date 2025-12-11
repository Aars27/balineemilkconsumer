// // ================= CART API =================
//
// import 'package:dio/dio.dart';
// import '../../../Components/Savetoken/utils_local_storage.dart';
// import 'CartModal.dart';
// import 'OrderSummary.dart';
//
// class CartApiService {
//   late final Dio _dio;
//
//   CartApiService() {
//     _dio = Dio(BaseOptions(
//       baseUrl: "https://balinee.pmmsapp.com/api",
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/json"
//       },
//     ));
//
//     // ✅ Add Token Automatically on Every Request
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final token = await LocalStorage.getApiToken();
//
//           print("🔑 Token: $token");
//           print("🚀 API Call: ${options.method} ${options.baseUrl}${options.path}");
//
//           if (token != null && token.isNotEmpty) {
//             options.headers["Authorization"] = "Bearer $token";
//           }
//
//           handler.next(options);
//         },
//         onResponse: (response, handler) {
//           print("✅ Response Status: ${response.statusCode}");
//           print("📥 Response Data: ${response.data}");
//           handler.next(response);
//         },
//         onError: (error, handler) {
//           print("❌ API Error: ${error.message}");
//           print("📍 Error Response: ${error.response?.data}");
//           handler.next(error);
//         },
//       ),
//     );
//   }
//
//   // ================= GET CART =================
//   Future<CartData?> getCart() async {
//     try {
//       print("\n📦 ========== GET CART ==========");
//       final response = await _dio.get("/cart");
//
//       print("🔍 Flag: ${response.data["flag"]}");
//
//       if (response.data["flag"] == true) {
//         print("✅ Parsing cart data...");
//         final cartData = CartData.fromJson(response.data["cart"]);
//         print("✅ Cart Items Count: ${cartData.items.length}");
//         print("✅ Subtotal: ${cartData.subtotal}");
//         return cartData;
//       } else {
//         print("❌ Flag is false");
//       }
//     } catch (e, stackTrace) {
//       print("❌ CART GET ERROR: $e");
//       print("📍 StackTrace: $stackTrace");
//     }
//     return null;
//   }
//
//   // ================= ADD ITEM =================
//   Future<bool> addToCart(int productId, int qty) async {
//     try {
//       print("\n➕ ========== ADD TO CART ==========");
//       print("📦 Product ID: $productId, Quantity: $qty");
//
//       final response = await _dio.post("/cart/add", data: {
//         "product_id": productId,
//         "quantity": qty,
//       });
//
//       print("🔍 Add Response Flag: ${response.data["flag"]}");
//       return response.data["flag"] == true;
//     } catch (e) {
//       print("❌ ADD CART ERROR: $e");
//       return false;
//     }
//   }
//
//   // ================= UPDATE QTY =================
//   Future<bool> updateCart(int cartItemId, int qty) async {
//     try {
//       print("\n🔄 ========== UPDATE CART ==========");
//       print("📦 Cart Item ID: $cartItemId, New Quantity: $qty");
//
//       final response = await _dio.post("/cart/update", data: {
//         "cart_item_id": cartItemId,
//         "quantity": qty,
//       });
//
//       print("🔍 Update Response Flag: ${response.data["flag"]}");
//       return response.data["flag"] == true;
//     } catch (e) {
//       print("❌ UPDATE CART ERROR: $e");
//       return false;
//     }
//   }
//
//   // ================= REMOVE ITEM =================
//   Future<bool> removeFromCart(int cartItemId) async {
//     try {
//       print("\n🗑️ ========== REMOVE FROM CART ==========");
//       print("📦 Cart Item ID: $cartItemId");
//
//       final response = await _dio.post("/cart/remove", data: {
//         "cart_item_id": cartItemId
//       });
//
//       print("🔍 Remove Response Flag: ${response.data["flag"]}");
//       return response.data["flag"] == true;
//     } catch (e) {
//       print("❌ REMOVE CART ERROR: $e");
//       return false;
//     }
//   }
//
//   // ================= ORDER SUMMARY =================
//   Future<OrderSummary?> getSummary() async {
//     try {
//       print("\n💰 ========== GET ORDER SUMMARY ==========");
//       final response = await _dio.get("/order-summary");
//
//       print("🔍 Summary Flag: ${response.data["flag"]}");
//
//       if (response.data["flag"] == true) {
//         print("✅ Parsing summary data...");
//         final summary = OrderSummary.fromJson(response.data["data"]);
//         print("✅ Total Amount: ${summary.totalAmount}");
//         return summary;
//       } else {
//         print("❌ Summary Flag is false");
//       }
//     } catch (e, stackTrace) {
//       print("❌ SUMMARY ERROR: $e");
//       print("📍 StackTrace: $stackTrace");
//     }
//     return null;
//   }
// }
