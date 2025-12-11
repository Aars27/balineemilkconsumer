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


      if (token != null && token.isNotEmpty) {

      } else {

        errorMessage = "Please login to continue";
        isLoading = false;
        notifyListeners();
        return;
      }

      final api = ApiService();




      banners = await api.getBanners();
      if (banners.isNotEmpty) {
      }

      // Fetch Categories
      categories = await api.getCategories();
      if (categories.isNotEmpty) {
      }

      // Fetch Best Sellers
      bestSellerProducts = await api.getBestSellers();
      if (bestSellerProducts.isNotEmpty) {
      }

      // Load user details and location
      await _loadUserDetails();
      await _loadLocation(context);


    } catch (e, stackTrace) {


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




  // -------------- OPEN CATEGORY PRODUCTS PAGE --------------
  Future<List<Map<String, dynamic>>> getCategoryProducts(int categoryId) async {
    final api = ApiService();
    return await api.getProductsByCategory(categoryId);
  }

// -------------- ADD TO CART (BEST SELLER) --------------
  Future<bool> addProductToCart(int productId) async {
    final api = ApiService();
    final success = await api.addToCart(
      productId: productId,
      quantity: 1,
    );

    return success;
  }












}