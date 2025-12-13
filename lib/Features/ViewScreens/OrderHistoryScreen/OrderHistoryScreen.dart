import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Core/Constant/app_colors.dart';
import '../../NotificationScreen/NotificationScreen.dart';
import 'OrderHistoryController.dart';
import 'OrderHistoryModal.dart';


class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<OrderHistoryController>().loadOrders();
  });
  }


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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
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
          color: isSelected ? AppColors.gradientEnd : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.gradientEnd : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.gradientEnd.withOpacity(0.3),
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
          color: isSelected ? AppColors.gradientEnd : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.gradientEnd : Colors.grey[300]!,
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
                   '${order.orderId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.date,
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
                  '₹${item.amount.toStringAsFixed(0)}',
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
                      color: AppColors.gradientEnd,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<OrderHistoryController>().reorder(order.orderId
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gradientEnd,
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