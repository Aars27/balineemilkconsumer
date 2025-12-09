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
          // 🔍 DEBUG: Check if token exists
          final token = await LocalStorage.getToken();

          if (kDebugMode) {
            print("═══════════════════════════════════════");
            print("🔑 TOKEN CHECK:");
            print("Token exists: ${token != null}");
            print("Token empty: ${token?.isEmpty ?? true}");
            if (token != null && token.isNotEmpty) {
              print("Token value: ${token.substring(0, token.length > 20 ? 20 : token.length)}...");
            } else {
              print("⚠️ TOKEN IS NULL OR EMPTY!");
            }
            print("═══════════════════════════════════════");
          }

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          } else {
            if (kDebugMode) {
              print("❌ NO TOKEN AVAILABLE - Request will fail!");
            }
          }

          if (kDebugMode) {
            print("\n📤 REQUEST:");
            print("${options.method} ${options.baseUrl}${options.path}");
            print("HEADERS: ${options.headers}");
            print("BODY: ${options.data}");
            print("───────────────────────────────────────\n");
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print("\n✅ RESPONSE:");
            print("Status: ${response.statusCode}");
            print("Data: ${response.data}");
            print("───────────────────────────────────────\n");
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print("\n❌ ERROR:");
            print("Message: ${error.message}");
            print("Status Code: ${error.response?.statusCode}");
            print("Response Data: ${error.response?.data}");
            print("───────────────────────────────────────\n");
          }
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
    return response.data as Map<String, dynamic>;
  }

  // ================= VERIFY OTP =================
  Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
    required String fcmToken,
  }) async {
    final requestData = {
      "user_id": userId,
      "otp": int.parse(otp),
      "fcm_token": fcmToken,
    };

    if (kDebugMode) {
      print("\n╔═══════════════════════════════════════╗");
      print("║       VERIFY OTP REQUEST              ║");
      print("╚═══════════════════════════════════════╝");
      print("Request Data: $requestData");
    }

    final response = await _dio.post("/verify-otp", data: requestData);

    if (kDebugMode) {
      print("\n╔═══════════════════════════════════════╗");
      print("║       VERIFY OTP RESPONSE             ║");
      print("╚═══════════════════════════════════════╝");
      print("Full Response: ${response.data}");

      // Check if token exists in response
      if (response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data') && data['data'] is Map) {
          final innerData = data['data'] as Map<String, dynamic>;
          print("\n🔑 TOKEN CHECK:");
          print("Token exists: ${innerData.containsKey('token')}");
          if (innerData.containsKey('token')) {
            final token = innerData['token'];
            print("Token value: ${token?.toString().substring(0, token.toString().length > 30 ? 30 : token.toString().length)}...");
          }
        }
      }
      print("═══════════════════════════════════════\n");
    }

    return response.data;
  }

  // ================= GET BANNERS =================
  Future<List<BannerModel>> getBanners() async {
    if (kDebugMode) {
      print("📱 Fetching Banners...");
    }

    final response = await _dio.get("/banner");

    if (response.data["flag"] == true) {
      final banners = (response.data["data"] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();

      if (kDebugMode) {
        print("✅ Banners loaded: ${banners.length}");
      }

      return banners;
    }
    return [];
  }

  // ================= GET BEST SELLERS =================
  Future<List<BestSellerModel>> getBestSellers() async {
    if (kDebugMode) {
      print("🏆 Fetching Best Sellers...");
    }

    final response = await _dio.get("/best-sellers");

    if (response.data["flag"] == true) {
      final products = (response.data["best_sellers"] as List)
          .map((e) => BestSellerModel.fromJson(e))
          .toList();

      if (kDebugMode) {
        print("✅ Best Sellers loaded: ${products.length}");
      }

      return products;
    }
    return [];
  }

  // ================= GET CATEGORIES =================
  Future<List<CategoryModel>> getCategories() async {
    if (kDebugMode) {
      print("📂 Fetching Categories...");
    }

    final response = await _dio.get("/category_master");

    if (response.data["flag"] == true) {
      final categories = (response.data["data"] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      if (kDebugMode) {
        print("✅ Categories loaded: ${categories.length}");
      }

      return categories;
    }
    return [];
  }
}