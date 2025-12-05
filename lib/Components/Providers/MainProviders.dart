import 'package:consumerbalinee/Features/ViewScreens/OnboardingScreen/OnBoardingController/Onbarding_Controller.dart';
import 'package:consumerbalinee/Features/ViewScreens/SplashScreen/SplashController/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Core/Router/router.dart';
import '../../Features/ViewScreens/LoginPageScreen/LoginController.dart';
import '../../Features/ViewScreens/OtpScreen/OtpController.dart';
import '../../Features/ViewScreens/SignupScreen/SignupControllar.dart';


class Mainproviders extends StatelessWidget {
  const Mainproviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashController()),
        ChangeNotifierProvider(create: (_) => OnboardingController()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => SignupController()),
        ChangeNotifierProvider(create: (_) => OtpController()),



      ],
      child: MaterialApp.router(
        title: 'BalineeMilk Consumer',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter,
      ),
    );
  }
}
