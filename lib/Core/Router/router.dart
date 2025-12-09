import 'package:consumerbalinee/Components/Savetoken/utils_local_storage.dart';
import "package:consumerbalinee/Features/ViewScreens/LoginPageScreen/LoginView.dart";
import "package:consumerbalinee/Features/ViewScreens/OnboardingScreen/Onboarding_Screen.dart";
import "package:consumerbalinee/Features/ViewScreens/SplashScreen/SplashView/SplashScreen.dart";
import "package:go_router/go_router.dart";
import "../../Features/NotificationScreen/NotificationScreen.dart";
import "../../Features/BottomPage/BootamPage.dart";

final GoRouter AppRouter = GoRouter(
  initialLocation: '/',

  // ✅ AUTO LOGIN LOGIC
  redirect: (context, state) async {
    // Always allow splash screen
    if (state.matchedLocation == '/') {
      return null;
    }

    // ✅ Check if user is logged in
    final token = await LocalStorage.getToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    // If logged in and trying to access login/onboarding, redirect to dashboard
    if (isLoggedIn &&
        (state.matchedLocation == '/loginpage' ||
            state.matchedLocation == '/onboarding')) {
      return '/bottombar';
    }

    // If not logged in and trying to access protected routes
    if (!isLoggedIn &&
        state.matchedLocation != '/loginpage' &&
        state.matchedLocation != '/onboarding') {
      return '/loginpage';
    }

    return null; // Allow navigation
  },

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Splashscreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/loginpage',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/bottombar',
      builder: (context, state) => MainWrapperScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationScreen(),
    ),
  ],
);