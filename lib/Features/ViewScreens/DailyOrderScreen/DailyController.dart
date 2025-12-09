// ==================== CONTROLLER ====================
import 'package:flutter/foundation.dart';

import 'DailyModal.dart';

class DailyOrderController extends ChangeNotifier {
  List<DailyOrder> _orders = [];
  bool _isLoading = false;
  String _selectedFilter = 'All'; // All, Active, Paused

  List<DailyOrder> get orders => _orders;
  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;

  DailyOrderController() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _orders = [
      DailyOrder(
        id: '1',
        productName: 'Full Cream Milk',
        productImage: 'assets/milk_pack.png',
        price: 35,
        quantity: 2,
        deliveryTime: '6:00 AM - 7:00 AM',
        deliveryDate: 'Every Day',
        isActive: true,
        status: 'delivered',
      ),
      DailyOrder(
        id: '2',
        productName: 'Fresh Curd',
        productImage: 'assets/curd.png',
        price: 40,
        quantity: 1,
        deliveryTime: '6:00 AM - 7:00 AM',
        deliveryDate: 'Every Day',
        isActive: true,
        status: 'scheduled',
      ),
      DailyOrder(
        id: '3',
        productName: 'Toned Milk',
        productImage: 'assets/milk_pack.png',
        price: 30,
        quantity: 1,
        deliveryTime: '6:00 AM - 7:00 AM',
        deliveryDate: 'Mon, Wed, Fri',
        isActive: false,
        status: 'pending',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void toggleOrderStatus(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = DailyOrder(
        id: _orders[index].id,
        productName: _orders[index].productName,
        productImage: _orders[index].productImage,
        price: _orders[index].price,
        quantity: _orders[index].quantity,
        deliveryTime: _orders[index].deliveryTime,
        deliveryDate: _orders[index].deliveryDate,
        isActive: !_orders[index].isActive,
        status: _orders[index].status,
      );
      notifyListeners();
    }
  }

  List<DailyOrder> get filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    if (_selectedFilter == 'Active') {
      return _orders.where((order) => order.isActive).toList();
    }
    return _orders.where((order) => !order.isActive).toList();
  }
}