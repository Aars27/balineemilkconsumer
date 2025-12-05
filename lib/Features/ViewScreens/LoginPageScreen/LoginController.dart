import 'package:flutter/material.dart';

import '../../../Components/Savetoken/utils_local_storage.dart';
import '../../../Core/Constant/ApiServices.dart';
import 'loginModal.dart';

class LoginController extends ChangeNotifier {
  final mobileController = TextEditingController();
  bool isLoading = false;

  Future<void> sendOtp(BuildContext context) async {
    final mobile = mobileController.text.trim();

    // ----------------------------
    // VALIDATION
    // ----------------------------
    if (mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10-digit mobile number")),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // ----------------------------
      // API CALL
      // ----------------------------
      final data = await ApiService().requestOtp(mobile);

      // Convert response to model
      final response = LoginResponse.fromJson(data);

      // ----------------------------
      // SUCCESS RESPONSE
      // ----------------------------
      if (response.flag) {
        // Save userId in local storage
        await LocalStorage.saveUserId(response.userId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );

        // TODO: Navigate to OTP screen after creating it
        // Navigator.pushNamed(context, "/otp");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      // ----------------------------
      // ERROR HANDLING
      // ----------------------------
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    isLoading = false;
    notifyListeners();
  }
}
