import 'dart:convert';

import 'package:consumerbalinee/Features/ViewScreens/DashBoardScreen/CategoryModal/CategoryModal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Components/Savetoken/utils_local_storage.dart';
import '../../Features/ViewScreens/DailyOrderScreen/DailyModal.dart';
import '../../Features/ViewScreens/DashBoardScreen/Bannermodal/BannerModal.dart';
import '../../Features/ViewScreens/DashBoardScreen/BestSellerModal/Best_Sellar_Modal.dart';
import '../../Features/ViewScreens/OrderHistoryScreen/OrderHistoryModal.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://balinee.pmmsapp.com/api",
        connectTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 50),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    // ✅ Add Token Automatically on Every Request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage.getApiToken();

          print(token);

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  // ================= SIGNUP =================
  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    final response = await _dio.post("/consumer-signup", data: data);
    return response.data as Map<String, dynamic>;
  }

  // ================= REQUEST OTP =================
  Future<Map<String, dynamic>> requestOtp(String mobile) async {
    final formData = FormData.fromMap({
      "mobile_no": mobile,
    });

    final response = await _dio.post("/consumer-login", data: formData);
    print(response);

    return response.data as Map<String, dynamic>;
  }

  // ================= VERIFY OTP =================
  Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
    required String fcmToken,
  }) async {
    final body = {
      "user_id": userId,
      "otp": int.parse(otp),
      "fcm_token": fcmToken,
    };

    try {
      print("========= SENDING BODY =========");
      print(body);

      final response = await _dio.post("/verify-otp", data: body);

      print("========= RAW RESPONSE =========");
      print(response);

      print("========= JSON ================");
      print(response.data);

      print("========= PRETTY JSON =========");
      print(const JsonEncoder.withIndent("  ").convert(response.data));

      return response.data;
    } catch (e, st) {
      print("========= ERROR ================");
      print(e);
      print(st);
      return {"flag": false, "message": "error", "data": null};
    }
  }


  // ================= GET BANNERS =================
  Future<List<BannerModel>> getBanners() async {
    final token = await LocalStorage.getApiToken();

    if (kDebugMode) {
      print("\n╔════════════════════════════════════════════════════════════╗");
      print("║               🎯 BANNER API CALL                          ║");
      print("╚════════════════════════════════════════════════════════════╝");
      print("📦 Stored Token from LocalStorage:");
      print(token ?? 'NO TOKEN SAVED');
      print("────────────────────────────────────────────────────────────");
      print("🔐 Sending Bearer Token:");
      print("Bearer $token");
      print("────────────────────────────────────────────────────────────");
    }

    final response = await _dio.get("/banner");

    if (kDebugMode) {
      print("\n✅ BANNER API RESPONSE:");
      print(response.data);
      print("════════════════════════════════════════════════════════════\n");
    }

    if (response.data["flag"] == true) {
      final banners = (response.data["data"] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();
      return banners;
    }
    return [];
  }

  // ================= GET BEST SELLERS =================
  Future<List<BestSellerModel>> getBestSellers() async {
    final token = await LocalStorage.getApiToken();

    if (kDebugMode) {
      print("\n╔════════════════════════════════════════════════════════════╗");
      print("║               🏆 BEST SELLERS API CALL                    ║");
      print("╚════════════════════════════════════════════════════════════╝");
      print("📦 Stored Token from LocalStorage:");
      print(token ?? 'NO TOKEN SAVED');
      print("────────────────────────────────────────────────────────────");
      print("🔐 Sending Bearer Token:");
      print("Bearer $token");
      print("────────────────────────────────────────────────────────────");
    }

    final response = await _dio.get("/best-sellers");

    if (kDebugMode) {
      print("\n✅ BEST SELLERS API RESPONSE:");
      print(response.data);
      print("════════════════════════════════════════════════════════════\n");
    }

    if (response.data["flag"] == true) {
      final products = (response.data["best_sellers"] as List)
          .map((e) => BestSellerModel.fromJson(e))
          .toList();
      return products;
    }
    return [];
  }

  // ================= GET CATEGORIES =================
  Future<List<CategoryModel>> getCategories() async {
    final token = await LocalStorage.getApiToken();

    if (kDebugMode) {
      print("\n╔════════════════════════════════════════════════════════════╗");
      print("║               📂 CATEGORIES API CALL                      ║");
      print("╚════════════════════════════════════════════════════════════╝");
      print("📦 Stored Token from LocalStorage:");
      print(token ?? 'NO TOKEN SAVED');
      print("────────────────────────────────────────────────────────────");
      print("🔐 Sending Bearer Token:");
      print("Bearer $token");
      print("────────────────────────────────────────────────────────────");
    }

    final response = await _dio.get("/category_master");

    if (kDebugMode) {
      print("\n✅ CATEGORIES API RESPONSE:");
      print(response.data);
      print("════════════════════════════════════════════════════════════\n");
    }

    if (response.data["flag"] == true) {
      final categories = (response.data["data"] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      return categories;
    }
    return [];
  }



  // ================= GET PRODUCTS BY CATEGORY =================
  Future<List<Map<String, dynamic>>> getProductsByCategory(int categoryId) async {
    final response = await _dio.get("/product-list/$categoryId");

    if (response.data["flag"] == true) {
      return (response.data["data"] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    }
    return [];
  }

// ================= ADD TO CART =================
  Future<bool> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final body = {
      "product_id": productId,
      "quantity": quantity,
    };

    final response = await _dio.post("/cart/add", data: body);

    return response.data["flag"] == true;
  }


  Future<OrderHistoryResponse> getOrderHistory() async {
    final response = await _dio.get("/order-history");
       print('this is histoyr:${response}');
    return OrderHistoryResponse.fromJson(response.data);
  }


// ================= GET DAILY ORDERED PRODUCTS =================
  Future<List<DailyOrder>> getDailyOrders() async {
    final token = await LocalStorage.getApiToken();

    print("🔐 Sending token: $token");

    try {
      final response = await _dio.get(
        "/daily-ordered-products",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("📥 DAILY ORDERS RESPONSE: ${response.data}");

      if (response.data["flag"] == true) {
        final list = (response.data["data"] as List)
            .map((e) => DailyOrder.fromJson(e))
            .toList();
        return list;
      }
    } catch (e) {
      print("❌ Daily Orders API Error: $e");
    }

    return [];
  }


















}