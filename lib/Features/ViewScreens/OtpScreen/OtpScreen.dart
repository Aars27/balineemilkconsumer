import 'package:consumerbalinee/Features/BottomPage/BootamPage.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../Core/Constant/app_colors.dart';
import 'OtpController.dart';

class OtpScreen extends StatelessWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OtpController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Illustration/Image
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 100,
                    color: AppColors.gradientEnd,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                "OTP Verification",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle with phone number
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF7F8C8D),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: "We've sent a verification code to\n",
                    ),
                    TextSpan(
                      text: mobile,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Pinput OTP Box with modern design
              Pinput(
                length: 6,
                controller: controller.otpController,
                defaultPinTheme: PinTheme(
                  height: 44,
                  width: 44,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 2,
                    ),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  height: 44,
                  width: 44,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF4A90E2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                submittedPinTheme: PinTheme(
                  height: 44,
                  width: 44,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF4A90E2),
                      width: 2,
                    ),
                  ),
                ),
                errorPinTheme: PinTheme(
                  height: 44,
                  width: 44,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE74C3C),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Verify Button
              SizedBox(
                width: 200,
                height: 44,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> MainWrapperScreen()));
                  },
                  // onPressed: controller.isLoading
                  //     ? null
                  //     : () {
                  //   controller.verifyOtp(context, mobile);
                  // },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gradientEnd,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: const Color(0xFFB0BEC5),
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    "Verify & Continue",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Resend OTP section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive code? ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.resendOtp(context, mobile),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF4A90E2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Security note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: const Color(0xFF7F8C8D),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "For security, please don't share your OTP with anyone",
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF7F8C8D),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}