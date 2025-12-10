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
  String? errorMessage;

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
    errorMessage = null;
    notifyListeners();

    try {
      // 🔍 CHECK TOKEN FIRST
      final token = await LocalStorage.getApiToken();

      print("\n╔════════════════════════════════════════════════╗");
      print("║         DASHBOARD DATA LOADING START          ║");
      print("╚════════════════════════════════════════════════╝");

      print("\n🔐 TOKEN STATUS:");
      print("─────────────────────────────────────────────────");
      print("Token exists: ${token != null}");
      print("Token empty: ${token?.isEmpty ?? true}");

      if (token != null && token.isNotEmpty) {
        print("✅ Token found!");
        print("Token length: ${token.length}");
        print("Token preview: ${token.substring(0, token.length > 30 ? 30 : token.length)}...");
      } else {
        print("❌ NO TOKEN FOUND!");
        print("⚠️  User needs to login first");
        errorMessage = "Please login to continue";
        isLoading = false;
        notifyListeners();
        return;
      }

      final api = ApiService();

      print("\n📊 FETCHING DASHBOARD DATA:");
      print("─────────────────────────────────────────────────");

      // Fetch Banners
      print("\n1️⃣ Fetching Banners...");
      banners = await api.getBanners();
      print("   ✅ Banners loaded: ${banners.length}");
      if (banners.isNotEmpty) {
        print("   📋 First banner ID: ${banners[0].id}");
        print("   📋 Banner image: ${banners[0].image}");
      }

      // Fetch Categories
      print("\n2️⃣ Fetching Categories...");
      categories = await api.getCategories();
      print("   ✅ Categories loaded: ${categories.length}");
      if (categories.isNotEmpty) {
        print("   📋 First category: ${categories[0].name}");
        print("   📋 Category image: ${categories[0].image ?? 'No image'}");
      }

      // Fetch Best Sellers
      print("\n3️⃣ Fetching Best Sellers...");
      bestSellerProducts = await api.getBestSellers();
      print("   ✅ Best Sellers loaded: ${bestSellerProducts.length}");
      if (bestSellerProducts.isNotEmpty) {
        print("   📋 First product: ${bestSellerProducts[0].name}");
        print("   📋 Product price: ₹${bestSellerProducts[0].price}");
        print("   📋 Product ID: ${bestSellerProducts[0].productId}");
      }

      // Load user details and location
      await _loadUserDetails();
      await _loadLocation(context);

      print("\n╔════════════════════════════════════════════════╗");
      print("║       ✅ DASHBOARD LOADED SUCCESSFULLY         ║");
      print("╚════════════════════════════════════════════════╝");
      print("📊 Summary:");
      print("   • Banners: ${banners.length}");
      print("   • Categories: ${categories.length}");
      print("   • Best Sellers: ${bestSellerProducts.length}");
      print("   • User: $userName");
      print("   • Location: $locationName");
      print("════════════════════════════════════════════════\n");

    } catch (e, stackTrace) {
      print("\n╔════════════════════════════════════════════════╗");
      print("║           ❌ DASHBOARD LOAD ERROR              ║");
      print("╚════════════════════════════════════════════════╝");
      print("Error: $e");
      print("Stack trace: $stackTrace");
      print("════════════════════════════════════════════════\n");

      errorMessage = "Failed to load dashboard data";

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
    print("\n🔄 Refreshing Dashboard...\n");
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

      print("\n👤 USER DETAILS:");
      print("   Name: $userName");
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

      print("\n📍 LOCATION:");
      print("   Address: $locationName");
    } catch (e) {
      print("❌ Error loading location: $e");
      locationName = "Location unavailable";
    }

    notifyListeners();
  }

  // --------------------------------------------------
  // HELPER METHODS
  // --------------------------------------------------
  bool get hasData {
    return banners.isNotEmpty ||
        categories.isNotEmpty ||
        bestSellerProducts.isNotEmpty;
  }

  bool get hasError {
    return errorMessage != null;
  }
}