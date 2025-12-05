import 'package:flutter/material.dart';
import '../../../Core/Constant/ApiServices.dart';

class OtpController extends ChangeNotifier {
  final otpController = TextEditingController();
  bool isLoading = false;

  // OTP Verification API
  Future<void> verifyOtp(BuildContext context, String mobile) async {
    final otp = otpController.text.trim();

    if (otp.length != 4) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter valid OTP")));
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().postData(
        "verify-otp",
        {"mobile": mobile, "otp": otp},
      );

      if (response["flag"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("OTP Verified Successfully")));

        // TODO: Save token & move to home screen
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"] ?? "Invalid OTP")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    isLoading = false;
    notifyListeners();
  }

  // Resend OTP
  Future<void> resendOtp(BuildContext context, String mobile) async {
    try {
      await ApiService().requestOtp(mobile);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP resent successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
