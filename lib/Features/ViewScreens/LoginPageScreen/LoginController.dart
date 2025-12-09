import 'package:flutter/material.dart';
import '../../../Auth/Firebase_service.dart';
import '../../../Components/Savetoken/utils_local_storage.dart';
import '../../../Core/Constant/ApiServices.dart';
import '../OtpScreen/OtpScreen.dart';
import 'loginModal.dart';

class LoginController extends ChangeNotifier {
  final mobileController = TextEditingController();
  bool isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> sendOtp(BuildContext context) async {
    final mobile = mobileController.text.trim();


    // ------------------ VALIDATION ------------------
    if (mobile.length != 10) {
      _msg(context, "Enter valid 10-digit mobile number");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // ------------------ FCM TOKEN ------------------
      String? fcmToken = await _firebaseService.getFCMToken();
      if (fcmToken != null) {
        await LocalStorage.saveFCMToken(fcmToken);
      }

      // ------------------ HIT LOGIN API ------------------
      final data = await ApiService().requestOtp(mobile);
      final response = LoginResponse.fromJson(data);

      print("LOGIN RESPONSE USER ID => ${response.userId}");

      if (response.flag) {
        // ------------------ SAVE USER ID ------------------
        await LocalStorage.saveUserId(response.userId);
        print("SAVED USER ID => ${response.userId}");

        _msg(context, response.message);

        // ------------------ NAVIGATE OTP SCREEN ------------------
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(mobile: mobile),
            ),
          );
        }
      } else {
        _msg(context, response.message);
      }
    } catch (e) {
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
    mobileController.dispose();
    super.dispose();
  }
}
