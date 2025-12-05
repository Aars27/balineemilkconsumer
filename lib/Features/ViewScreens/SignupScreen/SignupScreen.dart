import 'package:flutter/material.dart';

import '../../../Core/Constant/app_colors.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  int selectedRole = 3; // 3 = Consumer, 2 = Retailer, 1 = Wholesaler

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 15),
            const Text("Full Name",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),

            // ---------------- FULL NAME ----------------
            TextField(
              controller: nameController,
              decoration: _inputDecoration("Enter your name"),
            ),

            const SizedBox(height: 22),
            const Text("Phone Number",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),

            // ---------------- MOBILE NUMBER ----------------
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: _inputDecoration("10 digit mobile number")
                  .copyWith(counterText: ""),
            ),

            const SizedBox(height: 22),
            const Text("User Type",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            // ---------------- USER TYPE BUTTONS ----------------
            Row(
              children: [
                _roleButton("Consumer", 3, AppColors.gradientEnd),
                const SizedBox(width: 10),
                _roleButton("Retailer", 2, Colors.grey.shade200),
                const SizedBox(width: 10),
                _roleButton("Wholesaler", 1, Colors.grey.shade200),
              ],
            ),

            const SizedBox(height: 22),
            const Text("Delivery Address",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),

            // ---------------- ADDRESS FIELD ----------------
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: _inputDecoration("Enter complete address")
                  .copyWith(contentPadding: const EdgeInsets.all(14)),
            ),

            const SizedBox(height: 40),

            // ---------------- CREATE ACCOUNT BUTTON ----------------
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- LOGIN TEXT ----------------
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(
                      color: AppColors.gradientEnd,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------
  // SHARED INPUT DECORATION
  // ------------------------------------------------
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color:AppColors.gradientEnd, width: 1.2),
      ),
    );
  }

  // ------------------------------------------------
  // USER TYPE BUTTON
  // ------------------------------------------------
  Widget _roleButton(String label, int role, Color bgColor) {
    final bool isSelected = selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRole = role;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gradientEnd : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.gradientEnd : Colors.grey.shade400,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // SUBMIT (CALL API)
  // ------------------------------------------------
  void _submitForm(BuildContext context) {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    if (mobileController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid mobile number")),
      );
      return;
    }

    final body = {
      "first_name": nameController.text.trim(),
      "last_name": "",
      "mobile_no": mobileController.text.trim(),
      "role_id": selectedRole,
      "address": addressController.text.trim(),
    };

    print("SUBMIT DATA → $body");

    // Call your API here
    // ApiService().signup(body);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account Created Successfully")),
    );
  }
}
