import 'package:flutter/material.dart';

import 'ModalDashboard.dart';
// import 'package:http/http.dart' as http; // Uncomment when using API

class DashboardController extends ChangeNotifier {
  List<BannerModel> _banners = [];
  List<Product> _bestSellerProducts = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  int _cartCount = 0;

  List<BannerModel> get banners => _banners;
  List<Product> get bestSellerProducts => _bestSellerProducts;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  int get cartCount => _cartCount;

  DashboardController() {
    loadData();
  }

  // Load all data from API
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API calls - Replace with actual API endpoints
      await Future.wait([
        _loadBanners(),
        _loadBestSellers(),
        _loadCategories(),
      ]);
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load banners from API
  Future<void> _loadBanners() async {
    // TODO: Replace with actual API call
    // final response = await http.get(Uri.parse('YOUR_API_URL/banners'));
    // final data = jsonDecode(response.body);
    // _banners = (data as List).map((json) => BannerModel.fromJson(json)).toList();

    // Dummy data
    await Future.delayed(const Duration(milliseconds: 300));
    _banners = [
      BannerModel(
        id: '1',
        image: 'assets/milk_banner.png', // Replace with API image URL
        title: 'Milk',
        subtitle: 'Fresh & Pure Daily',
      ),
    ];
  }

  // Load best seller products from API
  Future<void> _loadBestSellers() async {
    // TODO: Replace with actual API call
    // final response = await http.get(Uri.parse('YOUR_API_URL/products/bestsellers'));
    // final data = jsonDecode(response.body);
    // _bestSellerProducts = (data as List).map((json) => Product.fromJson(json)).toList();

    // Dummy data
    await Future.delayed(const Duration(milliseconds: 500));
    _bestSellerProducts = [
      Product(
        id: '1',
        name: 'Full Cream Milk',
        image: 'assets/milk_pack.png',
        price: 35,
        unit: '500ml',
        isBestSeller: true,
      ),
      Product(
        id: '2',
        name: 'Toned Milk',
        image: 'assets/milk_pack.png',
        price: 35,
        unit: '500ml',
        isBestSeller: true,
      ),
      Product(
        id: '3',
        name: 'Organic Milk',
        image: 'assets/milk_pack.png',
        price: 35,
        unit: '500ml',
        isBestSeller: true,
      ),
    ];
  }

  // Load categories from API
  Future<void> _loadCategories() async {
    // TODO: Replace with actual API call
    // final response = await http.get(Uri.parse('YOUR_API_URL/categories'));
    // final data = jsonDecode(response.body);
    // _categories = (data as List).map((json) => Category.fromJson(json)).toList();

    // Dummy data
    await Future.delayed(const Duration(milliseconds: 500));
    _categories = [
      Category(id: '1', name: 'Milk', image: 'assets/categories/milk.png'),
      Category(id: '2', name: 'Curd', image: 'assets/categories/curd.png'),
      Category(id: '3', name: 'Butter', image: 'assets/categories/butter.png'),
      Category(id: '4', name: 'Ghee', image: 'assets/categories/ghee.png'),
      Category(id: '5', name: 'Chaas', image: 'assets/categories/chaas.png'),
      Category(id: '6', name: 'Cheese', image: 'assets/categories/cheese.png'),
      Category(id: '7', name: 'Paneer', image: 'assets/categories/paneer.png'),
      Category(id: '8', name: 'Khoa', image: 'assets/categories/khoa.png'),
    ];
  }

  void addToCart(Product product) {
    _cartCount++;
    notifyListeners();
    // TODO: Call API to add to cart
  }

  void removeFromCart(Product product) {
    if (_cartCount > 0) {
      _cartCount--;
      notifyListeners();
    }
    // TODO: Call API to remove from cart
  }

  // Refresh data
  Future<void> refresh() async {
    await loadData();
  }
}