import 'package:flutter/material.dart';

// ==================== VIEW ====================
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // 'delivered', 'pending', 'cancelled'

  Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.status,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

// ==================== CONTROLLER ====================
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



class Orderhistoryscreen extends StatelessWidget {
  const Orderhistoryscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderHistoryController(),
      child: const OrderHistoryView(),
    );
  }
}

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrderHistoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Background Vector Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Vector.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    children: [
                      Text(
                        'Order History',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          context,
                          controller,
                          'Past Orders',
                          true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTabButton(
                          context,
                          controller,
                          'Daily Orders',
                          false,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Filter Pills
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildFilterPill(context, controller, 'All'),
                      const SizedBox(width: 10),
                      _buildFilterPill(context, controller, 'Pending'),
                      const SizedBox(width: 10),
                      _buildFilterPill(context, controller, 'Delivered'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Orders List
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.filteredOrders.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: controller.filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = controller.filteredOrders[index];
                      return OrderCard(order: order);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
      BuildContext context,
      OrderHistoryController controller,
      String title,
      bool isPastOrders,
      ) {
    final isSelected = controller.selectedTab == title;

    return GestureDetector(
      onTap: () => controller.setTab(title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDB64E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFDB64E) : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFDB64E).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isPastOrders && !isSelected)
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.grey[600],
              ),
            if (!isPastOrders && !isSelected) const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(
      BuildContext context,
      OrderHistoryController controller,
      String filter,
      ) {
    final isSelected = controller.selectedFilter == filter;

    return GestureDetector(
      onTap: () => controller.setFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDB64E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFDB64E) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          filter,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Order Card Widget
class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM yyyy').format(order.date),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(order.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(order.status),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Order Items
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.name} × ${item.quantity}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '₹${item.price.toInt()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          )),

          const SizedBox(height: 12),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 12),

          // Total and Reorder Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${order.totalAmount.toInt()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFDB64E),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<OrderHistoryController>().reorder(order.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDB64E),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text(
                  'Reorder',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFFA726);
      case 'cancelled':
        return const Color(0xFFEF5350);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }
}