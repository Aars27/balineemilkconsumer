import 'package:flutter/material.dart';
import '../../../Core/Constant/ApiServices.dart';
import 'SignupModal.dart';

class SignupController extends ChangeNotifier {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  int selectedRole = 3; // consumer
  bool isLoading = false;

  // --------------------------
  // Change selected user type
  // --------------------------
  void updateRole(int role) {
    selectedRole = role;
    notifyListeners();
  }

  // --------------------------
  // SEND SIGNUP REQUEST
  // --------------------------
  Future<void> createAccount(BuildContext context) async {
    final fullName = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final address = addressController.text.trim();

    if (fullName.isEmpty || mobile.isEmpty || address.isEmpty) {
      _showMsg(context, "All fields are required");
      return;
    }

    if (mobile.length != 10) {
      _showMsg(context, "Enter valid 10-digit mobile number");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // split first + last name
      List<String> names = fullName.split(" ");
      String firstName = names.first;
      String lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

      final request = SignupRequest(
        firstName: firstName,
        lastName: lastName,
        mobileNo: mobile,
        roleId: selectedRole,
        address: address,
      );

      SignupResponse response = await ApiService().signup(request);

      if (response.flag) {
        _showMsg(context, response.message);

        // Navigate next (example)
        // Navigator.pushNamed(context, "/otp");
      } else {
        _showMsg(context, response.message);
      }
    } catch (e) {
      _showMsg(context, "Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
