import 'package:consumerbalinee/Features/ViewScreens/DashBoardScreen/DashboardScreeen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

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
        title: Text("Verify OTP"),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("OTP Sent To $mobile",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 30),

            // Pinput OTP Box
            Pinput(
              length: 4,
              controller: controller.otpController,
              defaultPinTheme: PinTheme(
                height: 55,
                width: 55,
                textStyle: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
                },

                // controller.isLoading
                //     ? null
                //     : () => controller.verifyOtp(context, mobile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Verify OTP",
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: () =>
                    controller.resendOtp(context, mobile),
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
