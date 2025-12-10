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

  Future<void> verifyOtp(BuildContext context, String mobile) async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      _msg(context, "Enter valid 6-digit OTP");
      return;
    }

    final userId = await LocalStorage.getUserId();
    final fcmToken = await LocalStorage.getFCMToken();

    if (userId == null) {
      _msg(context, "Session expired. Please login again.");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Call API
      final data = await ApiService().verifyOtp(
        userId: userId,
        otp: otp,
        fcmToken: fcmToken ?? "",
      );

      // Parse response
      final response = OtpVerifyResponse.fromJson(data);

      print(response);

      if (response.flag == false) {
        _msg(context, response.message);
        isLoading = false;
        notifyListeners();
        return;
      }

      // Save Token (comes from user.apiToken)
      if (response.user?.apiToken != null &&
          response.user!.apiToken!.isNotEmpty) {
        await LocalStorage.saveApiToken(response.user!.apiToken!);
      }

      // Save user data
      if (response.user != null) {
        await LocalStorage.saveUserData(response.user!);
      }

      _msg(context, response.message);

      if (context.mounted) {
        context.go('/bottombar');

        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            _requestLocationPermission(context);
          }
        });
      }
    } catch (e) {
      _msg(context, "Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    final locationProvider =
    Provider.of<LocationProvider>(context, listen: false);

    await locationProvider.fetchLocation();

    if (locationProvider.currentAddress.contains("denied")) {
      _showPermissionDialog(context);
    }
  }


  // ================= RESEND OTP =================
  Future<void> resendOtp(BuildContext context, String mobile) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService().requestOtp(mobile);

      final response = LoginResponse.fromJson(data);

      if (response.flag) {
        _msg(context, "OTP resent successfully");

        // Save new user_id again
        await LocalStorage.saveUserId(response.userId);
      } else {
        _msg(context, response.message);
      }
    } catch (e) {
      _msg(context, "Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }


  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
          "Please enable location permission in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  void _msg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
