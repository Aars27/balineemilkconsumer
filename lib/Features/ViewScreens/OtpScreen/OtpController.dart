import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../Components/Location/Location.dart';
import '../../../Components/Savetoken/utils_local_storage.dart';
import '../../../Core/Constant/ApiServices.dart';
import '../LoginPageScreen/loginModal.dart';
import 'OtpModal.dart';

class OtpController extends ChangeNotifier {
  final otpController = TextEditingController();
  bool isLoading = false;

  // ================= VERIFY OTP =================
  Future<void> verifyOtp(BuildContext context, String mobile) async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      _msg(context, "Enter valid 6-digit OTP");
      return;
    }

    // Get saved userId and FCM token
    final userId = await LocalStorage.getUserId();
    final fcmToken = await LocalStorage.getFCMToken();

    if (userId == null) {
      _msg(context, "Session expired. Please login again.");
      return;
    }

    print("========== OTP CONTROLLER DATA ==========");
    print("User ID: $userId");
    print("OTP: $otp");
    print("FCM Token: $fcmToken");
    print("Mobile: $mobile");
    print("=========================================");

    isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService().verifyOtp(
        userId: userId,
        otp: otp,
        fcmToken: fcmToken ?? "",
      );

      print("========== CONTROLLER RESPONSE ==========");
      print("Raw Response: $data");
      print("=========================================");

      final response = OtpVerifyResponse.fromJson(data);

      print("========== PARSED RESPONSE ==========");
      print("Flag: ${response.flag}");
      print("Message: ${response.message}");
      print("Token: ${response.token}");
      print("User: ${response.user}");
      print("=====================================");

      if (response.flag) {
        // Save token
        if (response.token != null) {
          await LocalStorage.saveToken(response.token!);
          print("✅ Token saved successfully");
        }

        // Save user data
        if (response.user != null) {
          await LocalStorage.saveUserData(response.user!);
          print("✅ User data saved successfully");
        }

        _msg(context, response.message);

        // Navigate to bottom bar and request location permission
        if (context.mounted) {
          context.go('/bottombar');

          // Request location permission after navigation06
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              _requestLocationPermission(context);
            }
          });
        }
      } else {
        _msg(context, response.message);
      }
    } catch (e, stackTrace) {
      print("========== ERROR ==========");
      print("Error: $e");
      print("StackTrace: $stackTrace");
      print("===========================");
      _msg(context, "Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ================= REQUEST LOCATION PERMISSION =================
  Future<void> _requestLocationPermission(BuildContext context) async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.fetchLocation();

    // If permission denied, show dialog
    if (locationProvider.currentAddress.contains("denied") ||
        locationProvider.currentAddress.contains("disabled")) {
      if (context.mounted) {
        _showLocationPermissionDialog(context);
      }
    }
  }

  // ================= SHOW LOCATION PERMISSION DIALOG =================
  void _showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'This app needs location access to provide better services. Please enable location permission in settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Open app settings
                await Geolocator.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  // ================= RESEND OTP =================
  Future<void> resendOtp(BuildContext context, String mobile) async {
    isLoading = true;
    notifyListeners();

    try {
      print("========== RESEND OTP REQUEST ==========");
      print("Mobile: $mobile");
      print("========================================");

      final data = await ApiService().requestOtp(mobile);

      print("========== RESEND OTP RESPONSE ==========");
      print("Raw Response: $data");
      print("=========================================");

      final response = LoginResponse.fromJson(data);

      print("========== PARSED RESEND RESPONSE ==========");
      print("Flag: ${response.flag}");
      print("Message: ${response.message}");
      print("===========================================");

      if (response.flag) {
        _msg(context, "OTP resent successfully");
      } else {
        _msg(context, response.message);
      }
    } catch (e, stackTrace) {
      print("========== RESEND ERROR ==========");
      print("Error: $e");
      print("StackTrace: $stackTrace");
      print("==================================");
      _msg(context, "Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void _msg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}