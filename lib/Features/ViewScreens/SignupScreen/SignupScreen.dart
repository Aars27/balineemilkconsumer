import 'package:consumerbalinee/Features/ViewScreens/LoginPageScreen/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // go_router import
import 'package:provider/provider.dart'; // Assuming you use Provider

import '../../../Core/Constant/app_colors.dart';
import 'SignupControllar.dart';




class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // We will manage state locally, but call controller for submit
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final lastNameController = TextEditingController();

  // New Role IDs: 5 = Consumer (Default), 4 = Retailer, 3 = Wholesaler
  int selectedRole = 5;

  @override
  void initState() {
    super.initState();
    // Initialize controllers from a context if using Provider
    // For simplicity, we keep them local here.
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the controller if it's managed by Provider
    // final controller = context.watch<SignupController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ... AppBar code ...
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... Full Name, Last Name, Phone Number TextFields ...
              const Text("Full Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(controller: nameController, decoration: _inputDecoration("Enter your name")),
              const SizedBox(height: 18),
              const Text("Last Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(controller: lastNameController, decoration: _inputDecoration("Enter your last name")),
              const SizedBox(height: 18),
              const Text("Phone Number",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: _inputDecoration("10 digit mobile number").copyWith(counterText: ""),
              ),
              const SizedBox(height: 18),
              const Text("User Type",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),

              // ---------------- USER TYPE BUTTONS (Updated Role IDs) ----------------
              Row(
                children: [
                  // Consumer: 5
                  _roleButton("Consumer", 5, AppColors.gradientEnd),
                  const SizedBox(width: 10),
                  // Retailer: 4
                  _roleButton("Retailer", 4, Colors.grey.shade200),
                  const SizedBox(width: 10),
                  // Wholesaler: 3
                  _roleButton("Wholesaler", 3, Colors.grey.shade200),
                ],
              ),
              // ... rest of the fields ...
              const SizedBox(height: 22),
              const Text("Delivery Address",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(
                controller: addressController,
                maxLines: 3,
                decoration: _inputDecoration("Enter complete address")
                    .copyWith(contentPadding: const EdgeInsets.all(14)),
              ),

              const SizedBox(height: 20),

              // ---------------- CREATE ACCOUNT BUTTON ----------------
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Call the local submit function which uses the Controller's logic
                      _submitForm(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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

              const SizedBox(height: 10),

              // ---------------- LOGIN TEXT ----------------
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Use go_router for consistency
                    // context.go('/login');

                    Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
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
      ),
    );
  }

  // ------------------------------------------------
  // SHARED INPUT DECORATION
  // ------------------------------------------------
  InputDecoration _inputDecoration(String hint) {
    // ... same as before
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
            selectedRole = role; // Update the local state
            // If using Provider, you might also call:
            // context.read<SignupController>().updateRole(role);
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
                fontSize: 12
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // SUBMIT (Call Controller)
  // ------------------------------------------------
  void _submitForm(BuildContext context) {
    // This is a simplified local submission that uses the original logic
    // but relies on the updated SignupController for the final API call.

    final controller = SignupController(); // A temporary instance, ideally use Provider

    // Manually setting controller values based on local state (Not ideal for Provider architecture)
    // If you were using Provider, you'd only call controller.createAccount(context);
    controller.nameController.text = nameController.text;
    controller.mobileController.text = mobileController.text;
    controller.addressController.text = addressController.text;
    controller.selectedRole = selectedRole;

    controller.createAccount(context);
  }
}