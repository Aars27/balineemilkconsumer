import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DailyController.dart';
import 'DailyModal.dart';

class DailyOrderView extends StatefulWidget {
  const DailyOrderView({super.key});

  @override
  State<DailyOrderView> createState() => _DailyOrderViewState();
}

class _DailyOrderViewState extends State<DailyOrderView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DailyOrderController>().loadDailyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DailyOrderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ======= BACKGROUND VECTOR IMAGE =======
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

          // ========== MAIN CONTENT ==========
          CustomScrollView(
            slivers: [
              // ======== APP BAR DESIGN =========
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Orders',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          'Manage your subscriptions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ======= FILTER CHIPS =========
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      _buildFilterChip(context, controller, 'All', Icons.list_alt),
                      const SizedBox(width: 12),
                      _buildFilterChip(context, controller, 'Active', Icons.check_circle),
                      const SizedBox(width: 12),
                      _buildFilterChip(context, controller, 'Paused', Icons.pause_circle),
                    ],
                  ),
                ),
              ),

              // ====== DAILY ORDER LIST ======
              controller.isLoading
                  ? const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
                  : controller.filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final order = controller.filteredOrders[index];
                      return DailyOrderCard(order: order);
                    },
                    childCount: controller.filteredOrders.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== Filter Chip Widget =====
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

  // ====== EMPTY UI ======
  SliverFillRemaining _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// =============== UPDATED DAILY ORDER CARD (WORKING) =================
// ===================================================================

class DailyOrderCard extends StatelessWidget {
  final DailyOrder order;

  const DailyOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final imageUrl = "https://balinee.pmmsapp.com/${order.image}";

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
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // === PRODUCT IMAGE ===
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40, color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // === PRODUCT DETAILS ===
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.productName,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(
                        "${order.totalQty} × ₹${order.price}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${order.totalOrders} Orders",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // === STATUS BADGE ===
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: order.isActive ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.isActive ? "Active" : "Paused",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: order.isActive ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[200]),

          // ===== FOOTER =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // PRODUCT ID (API doesn't send delivery date)
                Row(
                  children: [
                    const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      "Product ID: ${order.id}",
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),

                // ==== ACTION BUTTONS ====
                Row(
                  children: [
                    // Edit button
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit_outlined, size: 20, color: Colors.grey[600]),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Pause / Resume
                    IconButton(
                      onPressed: () {
                        context.read<DailyOrderController>().toggleOrderStatus(order.id);
                      },
                      icon: Icon(
                        order.isActive ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: order.isActive ? Colors.orange : Colors.green,
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
