import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Components/Location/Location.dart';
import '../../../Components/Savetoken/utils_local_storage.dart';
import '../../../Core/Constant/ApiServices.dart';
import 'Bannermodal/BannerModal.dart';
import 'BestSellerModal/Best_Sellar_Modal.dart';
import 'CategoryModal/CategoryModal.dart';

class DashboardController extends ChangeNotifier {
  bool isLoading = false;

  List<BannerModel> banners = [];
  List<BestSellerModel> bestSellerProducts = [];
  List<CategoryModel> categories = [];

  String userName = "User";
  String locationName = "Fetching...";

  // --------------------------------------------------
  // LOAD DASHBOARD DATA
  // --------------------------------------------------
  Future<void> loadDashboard(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      // 🔍 CHECK TOKEN FIRST
      final token = await LocalStorage.getToken();
      print("\n🔐 TOKEN STATUS BEFORE API CALLS:");
      print("Token exists: ${token != null}");
      print("Token empty: ${token?.isEmpty ?? true}");
      if (token != null && token.isNotEmpty) {
        print("Token length: ${token.length}");
        print("Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...");
      } else {
        print("⚠️ NO TOKEN FOUND - API calls will fail!");
        print("Please make sure user is logged in first.\n");
      }

      final api = ApiService();

      // Fetch all data in parallel for better performance
      final results = await Future.wait([
        api.getBanners(),
        api.getCategories(),
        api.getBestSellers(),
      ]);

      banners = results[0] as List<BannerModel>;
      categories = results[1] as List<CategoryModel>;
      bestSellerProducts = results[2] as List<BestSellerModel>;

      // Load user details and location
      await _loadUserDetails();
      await _loadLocation(context);

      print("✅ Dashboard loaded successfully");
      print("Banners: ${banners.length}");
      print("Categories: ${categories.length}");
      print("Best Sellers: ${bestSellerProducts.length}");

    } catch (e) {
      print("❌ Dashboard Load Error: $e");

      // Set empty lists to prevent null errors
      banners = [];
      categories = [];
      bestSellerProducts = [];
    }

    isLoading = false;
    notifyListeners();
  }

  // --------------------------------------------------
  // REFRESH
  // --------------------------------------------------
  Future<void> refresh(BuildContext context) async {
    await loadDashboard(context);
  }

  // --------------------------------------------------
  // LOAD USER DATA FROM LOCAL STORAGE
  // --------------------------------------------------
  Future<void> _loadUserDetails() async {
    try {
      final user = await LocalStorage.getUserData();

      if (user != null && user.fullName != null) {
        userName = user.fullName!;
      } else {
        userName = "User";
      }

      print("👤 User: $userName");
    } catch (e) {
      print("❌ Error loading user details: $e");
      userName = "User";
    }

    notifyListeners();
  }

  // --------------------------------------------------
  // LOAD LOCATION FROM PROVIDER
  // --------------------------------------------------
  Future<void> _loadLocation(BuildContext context) async {
    try {
      final locationProvider =
      Provider.of<LocationProvider>(context, listen: false);

      await locationProvider.fetchLocation();

      locationName = locationProvider.currentAddress;

      print("📍 Location: $locationName");
    } catch (e) {
      print("❌ Error loading location: $e");
      locationName = "Location unavailable";
    }

    notifyListeners();
  }
}