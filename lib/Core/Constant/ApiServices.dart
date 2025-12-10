import 'dart:convert';

import 'package:consumerbalinee/Features/ViewScreens/DashBoardScreen/CategoryModal/CategoryModal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../Components/Savetoken/utils_local_storage.dart';
import '../../Features/ViewScreens/DashBoardScreen/Bannermodal/BannerModal.dart';
import '../../Features/ViewScreens/DashBoardScreen/BestSellerModal/Best_Sellar_Modal.dart';

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
}