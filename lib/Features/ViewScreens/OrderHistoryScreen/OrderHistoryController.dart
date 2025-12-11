import 'package:flutter/material.dart';
import '../../../Components/Savetoken/utils_local_storage.dart';
import '../../../Core/Constant/ApiServices.dart';
import 'OrderHistoryModal.dart';

class OrderHistoryController extends ChangeNotifier {
  bool isLoading = false;

  String selectedTab = "Past Orders";
  String selectedFilter = "All";

  List<Order> orders = [];
  List<Order> filteredOrders = [];

  // LOAD API
  Future<void> loadOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await LocalStorage.getApiToken();

      if (token == null || token.isEmpty) {
        isLoading = false;
        filteredOrders = [];
        notifyListeners();
        return;
      }

      final api = ApiService();
      final response = await api.getOrderHistory();

      orders = response.orders;
      filteredOrders = orders;

      applyFilter();
    } catch (e) {
      orders = [];
      filteredOrders = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void setTab(String tab) {
    selectedTab = tab;
    applyFilter();
    notifyListeners();
  }

  void setFilter(String filter) {
    selectedFilter = filter;
    applyFilter();
    notifyListeners();
  }

  void applyFilter() {
    filteredOrders = orders.where((o) {
      if (selectedFilter == "All") return true;
      return o.status.toLowerCase() == selectedFilter.toLowerCase();
    }).toList();
  }

  void reorder(String orderId) {
    print("Reorder: $orderId");
  }
}
