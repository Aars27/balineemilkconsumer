import 'package:consumerbalinee/Core/Constant/app_colors.dart';
import 'package:consumerbalinee/Core/Constant/text_constants.dart';
import 'package:consumerbalinee/Features/ViewScreens/SplashScreen/SplashController/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../Components/Savetoken/utils_local_storage.dart';
import '../../../../Core/Constant/app_images.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override

  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // ✅ Check if user is logged in
    final token = await LocalStorage.getToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    print("\n🔍 SPLASH SCREEN - TOKEN CHECK:");
    print("Is Logged In: $isLoggedIn");
    print("Token: ${token ?? 'NULL'}\n");

    if (isLoggedIn) {
      // ✅ Token exists - Go to dashboard
      context.go('/bottombar');
    } else {
      // ❌ No token - Go to onboarding/login
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.routeBackgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.appLogo,width: 150,),
              SizedBox(
                height: 20,
              ),
              Text('Your Dairy Delivery Partner',style: TextConstants.headingStyle.copyWith(color:Colors.white),),
            SizedBox(
              height: 10,
            ),
              CircularProgressIndicator(
                color: Colors.white,
              )

            ],
          ),
        ),
      ),
    );
  }
}
