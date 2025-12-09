import 'package:consumerbalinee/Core/Constant/text_constants.dart';
import 'package:consumerbalinee/Features/ViewScreens/SignupScreen/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Constant/app_colors.dart';
import '../SignupScreen/SignupControllar.dart';
import 'LoginController.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();

    return Scaffold(
      backgroundColor: AppColors.logincolor ,                // Soft milky background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------------------------------------------
            // Header with Milk Illustration
            // ---------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: Column(
                children: [
                  Image.asset('assets/Balinee-milk.gif',width: 200,),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome to Balinee Milk",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2A4B7C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Freshness delivered to your doorstep",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ---------------------------------------------------
            // Login Card
            // ---------------------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter Mobile Number",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2A4B7C),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ---------------------------------------------------
                  // Mobile Number Field
                  // ---------------------------------------------------
                  TextField(
                    controller: controller.mobileController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      prefixIcon: const Icon(Icons.phone_iphone),
                      filled: true,
                      fillColor: const Color(0xffF1F7FF),
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ---------------------------------------------------
                  // Send OTP Button
                  // ---------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                        await controller.sendOtp(context);

                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gradientEnd,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: controller.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Send OTP",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(child: TextButton(

                      onPressed: () async {
                        await context.read<SignupController>().createAccount(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateAccountScreen()
                          ),
                        );
                      },



                      child: Text('Click to Signup',style: TextConstants.subHeadingStyle.copyWith(color: AppColors.gradientEnd))))
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Balinee Fresh Milk • Since 2013",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
