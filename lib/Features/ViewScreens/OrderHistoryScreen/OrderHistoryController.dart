// ==================== CONTROLLER ====================
import 'package:flutter/foundation.dart';

import 'OrderHistoryModal.dart';

class OrderHistoryController extends ChangeNotifier {
  String _selectedTab = 'Past Orders'; // 'Past Orders' or 'Daily Orders'
  String _selectedFilter = 'All'; // 'All', 'Pending', 'Delivered'
  List<Order> _orders = [];
  bool _isLoading = false;

  String get selectedTab => _selectedTab;
  String get selectedFilter => _selectedFilter;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  OrderHistoryController() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _orders = [
      Order(
        id: '1',
        orderNumber: '#234567',
        date: DateTime(2024, 11, 29),
        items: [
          OrderItem(name: 'Fresh Cow Milk', quantity: 2, price: 120),
          OrderItem(name: 'Premium Curd', quantity: 1, price: 50),
        ],
        totalAmount: 170,
        status: 'delivered',
      ),
      Order(
        id: '2',
        orderNumber: '#134567',
        date: DateTime(2024, 11, 25),
        items: [
          OrderItem(name: 'Fresh Paneer', quantity: 1, price: 80),
          OrderItem(name: 'Pure Ghee', quantity: 1, price: 600),
        ],
        totalAmount: 680,
        status: 'delivered',
      ),
      Order(
        id: '3',
        orderNumber: '#034567',
        date: DateTime(2024, 11, 22),
        items: [
          OrderItem(name: 'White Butter', quantity: 2, price: 240),
          OrderItem(name: 'Buffalo Milk', quantity: 1, price: 70),
        ],
        totalAmount: 310,
        status: 'delivered',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<Order> get filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    return _orders
        .where((order) =>
    order.status.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  void reorder(String orderId) {
    // Implement reorder logic
    print('Reordering: $orderId');
  }
}
