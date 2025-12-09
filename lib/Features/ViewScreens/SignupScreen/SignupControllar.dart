import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Core/Constant/ApiServices.dart';
import 'SignupModal.dart';

class SignupController extends ChangeNotifier {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  int selectedRole = 3; // default Consumer
  bool isLoading = false;

  void updateRole(int role) {
    selectedRole = role;
    notifyListeners();
  }

  Future<void> createAccount(BuildContext context) async {
    final fullName = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final address = addressController.text.trim();

    if (fullName.isEmpty || mobile.isEmpty || address.isEmpty) {
      _msg(context, "All fields are required");
      return;
    }

    if (mobile.length != 10) {
      _msg(context, "Enter valid 10-digit number");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      List<String> nameParts = fullName.split(" ");
      String firstName = nameParts.first;
      String lastName =
      nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

      // Create request map directly
      final requestData = {
        "first_name": firstName,
        "last_name": lastName,
        "mobile_no": mobile,
        "role_id": selectedRole,
        "address": address,
      };

      // Call API and get Map response
      final responseData = await ApiService().signup(requestData);

      // Convert to SignupResponse model
      final response = SignupResponse.fromJson(responseData);

      if (response.flag) {
        _msg(context, response.message);

        // NEXT STEP → Go to OTP page
        // Navigator.pushNamed(context, "/otp", arguments: mobile);
        context.go('/login');
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
  }
}

