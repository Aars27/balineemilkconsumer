import 'package:flutter/material.dart';
import '../../../Core/Constant/ApiServices.dart';
import 'DailyModal.dart';

class DailyOrderController extends ChangeNotifier {
  List<DailyOrder> allOrders = [];
  List<DailyOrder> filteredOrders = [];

  String selectedFilter = "All";
  bool isLoading = false;

  DailyOrderController() {
    loadDailyOrders();
  }

  Future<void> loadDailyOrders() async {
    isLoading = true;
    notifyListeners();

    final api = ApiService();
    allOrders = await api.getDailyOrders();

    applyFilter();
    isLoading = false;
    notifyListeners();
  }

  // ---------------- FILTER ORDERS ----------------
  void setFilter(String filter) {
    selectedFilter = filter;
    applyFilter();
    notifyListeners();
  }

  void applyFilter() {
    if (selectedFilter == "All") {
      filteredOrders = List.from(allOrders);
    } else if (selectedFilter == "Active") {
      filteredOrders = allOrders.where((o) => o.isActive).toList();
    } else if (selectedFilter == "Paused") {
      filteredOrders = allOrders.where((o) => !o.isActive).toList();
    }
  }

  // ---------------- TOGGLE ACTIVE/PAUSE ----------------
  void toggleOrderStatus(int productId) {
    final index = allOrders.indexWhere((o) => o.id == productId);
    if (index != -1) {
      allOrders[index].isActive = !allOrders[index].isActive;
      applyFilter();
      notifyListeners();
    }
  }
}
