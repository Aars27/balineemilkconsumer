import 'package:flutter/material.dart';

// ==================== VIEW ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ==================== MODEL ====================

class DailyOrder {
  final String id;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String deliveryTime;
  final String deliveryDate;
  final bool isActive;
  final String status; // 'delivered', 'pending', 'scheduled'

  DailyOrder({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.deliveryTime,
    required this.deliveryDate,
    this.isActive = true,
    this.status = 'scheduled',
  });
}

// ==================== CONTROLLER ====================
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


class Dailyorderscreen extends StatelessWidget {
  const Dailyorderscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DailyOrderController(),
      child: const DailyOrderView(),
    );
  }
}


class DailyOrderView extends StatefulWidget {
  const DailyOrderView({super.key});

  @override
  State<DailyOrderView> createState() => _DailyOrderViewState();
}

class _DailyOrderViewState extends State<DailyOrderView> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DailyOrderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Vector Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Vector.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),


          // Main Content
          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                expandedHeight: 120,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.grey[800]),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Orders',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your subscriptions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Filter Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      _buildFilterChip(
                        context,
                        controller,
                        'All',
                        Icons.list_alt,
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        context,
                        controller,
                        'Active',
                        Icons.check_circle,
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        context,
                        controller,
                        'Paused',
                        Icons.pause_circle,
                      ),
                    ],
                  ),
                ),
              ),

              // Orders List
              controller.isLoading
                  ? const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
                  : controller.filteredOrders.isEmpty
                  ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No orders found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final order =
                      controller.filteredOrders[index];
                      return DailyOrderCard(order: order);
                    },
                    childCount: controller.filteredOrders.length,
                  ),
                ),
              ),
            ],
          ),

          // Floating Add Button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Navigate to add new subscription
              },
              backgroundColor: const Color(0xFF4A90E2),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'New Order',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context,
      DailyOrderController controller,
      String label,
      IconData icon,
      ) {
    final isSelected = controller.selectedFilter == label;

    return GestureDetector(
      onTap: () => controller.setFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
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
}

// Daily Order Card Widget
class DailyOrderCard extends StatelessWidget {
  final DailyOrder order;

  const DailyOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      order.productImage,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.local_drink,
                          size: 40,
                          color: const Color(0xFF4A90E2),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.quantity} x Rs.${order.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order.deliveryTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: order.isActive
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.isActive ? 'Active' : 'Paused',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: order.isActive
                          ? const Color(0xFF4CAF50)
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey[200]),

          // Order Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Delivery Schedule
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.deliveryDate,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                // Action Buttons
                Row(
                  children: [
                    // Edit Button
                    IconButton(
                      onPressed: () {
                        // Navigate to edit screen
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Pause/Resume Button
                    IconButton(
                      onPressed: () {
                        context
                            .read<DailyOrderController>()
                            .toggleOrderStatus(order.id);
                      },
                      icon: Icon(
                        order.isActive ? Icons.pause : Icons.play_arrow,
                        size: 20,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: order.isActive
                            ? Colors.orange
                            : const Color(0xFF4CAF50),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}