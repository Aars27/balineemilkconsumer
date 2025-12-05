import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Features/ViewScreens/SignupScreen/SignupModal.dart';

class ApiService {
  static const String baseUrl = "https://balinee.pmmsapp.com/api/";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  ApiService() {
    _initializeInterceptors();
  }

  // -----------------------------------------------------
  // ADD TOKEN TO API REQUESTS
  // -----------------------------------------------------
  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString("api_token");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print("❌ API Error: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  // -----------------------------------------------------
  // GENERAL GET
  // -----------------------------------------------------
  Future<dynamic> getData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } catch (e) {
      throw Exception("GET error: $e");
    }
  }

  // -----------------------------------------------------
  // GENERAL POST
  // -----------------------------------------------------
  Future<dynamic> postData(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      return response.data;
    } catch (e) {
      throw Exception("POST error: $e");
    }
  }

  Future<Map<String, dynamic>> requestOtp(String mobile) async {
    try {
      final response = await _dio.post(
        "consumer-login",
        data: {
          "mobile": mobile,
        },
      );

      final data = response.data;

      // Save userId (data = 40)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_id", data["data"].toString());

      print("✅ OTP Request Success");
      print("User ID stored: ${data["data"]}");

      return data;
    } catch (e) {
      throw Exception("OTP Login error: $e");
    }
  }


  // ------------------------------
// SIGNUP API
// ------------------------------
  Future<SignupResponse> signup(SignupRequest request) async {
    try {
      final response = await _dio.post(
        "consumer-signup",
        data: request.toJson(),
      );

      return SignupResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Signup Error: $e");
    }
  }









}
