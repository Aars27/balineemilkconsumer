import 'package:consumerbalinee/Features/ViewScreens/DashBoardScreen/ControllerDashboard.dart';
import 'package:consumerbalinee/Features/ViewScreens/OnboardingScreen/OnBoardingController/Onbarding_Controller.dart';
import 'package:consumerbalinee/Features/ViewScreens/SplashScreen/SplashController/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Auth/Firebase_service.dart';
import '../../Core/Router/router.dart';
import '../../Features/ViewScreens/CartScreen/CartController.dart';
import '../../Features/ViewScreens/DailyOrderScreen/DailyController.dart';
import '../../Features/ViewScreens/LoginPageScreen/LoginController.dart';
import '../../Features/ViewScreens/OrderHistoryScreen/OrderHistoryController.dart';
import '../../Features/ViewScreens/OtpScreen/OtpController.dart';
import '../../Features/ViewScreens/SignupScreen/SignupControllar.dart';
import '../Location/Location.dart';
import '../Savetoken/utils_local_storage.dart';


class Mainproviders extends StatefulWidget {
  const Mainproviders({super.key});

  @override
  State<Mainproviders> createState() => _MainprovidersState();
}

class _MainprovidersState extends State<Mainproviders> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _setupFirebase();
  }

  void _setupFirebase() {
    // Setup foreground notification handler
    _firebaseService.setupForegroundNotificationHandler();

    // Listen to token refresh
    _firebaseService.listenToTokenRefresh((newToken) async {
      await LocalStorage.saveFCMToken(newToken);
      // TODO: Send new token to backend if user is logged in
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashController()),
        ChangeNotifierProvider(create: (_) => OnboardingController()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => SignupController()),
        ChangeNotifierProvider(create: (_) => OtpController()),
        ChangeNotifierProvider(create: (_) => DailyOrderController()),
        ChangeNotifierProvider(create: (_) =>  CartController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => OrderHistoryController()),




      ],
      child: MaterialApp.router(
        title: 'BalineeMilk Consumer',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter,
      ),
    );
  }
}
