import 'package:consumerbalinee/Features/BottomPage/BootamPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'CartController.dart';
import 'CartModal.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {



  @override
  void initState() {
    super.initState();
    print("🟢🟢🟢 CartView initState called");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🟢🟢🟢 Loading cart data...");
      context.read<CartController>().loadCartAndSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartController>();

    print("🟢 Building CartView - isLoading: ${controller.isLoading}");
    print("🟢 Cart items count: ${controller.cartItems.length}");

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
          Column(
            children: [
              // Custom App Bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Cart',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '${controller.totalQuantity} items',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (controller.itemCount > 0)
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[400],
                            size: 28,
                          ),
                          onPressed: () {
                            _showClearCartDialog(context, controller);
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Content Area
              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.cartItems.isEmpty
                    ? _buildEmptyCart(context)
                    : _buildCartContent(context, controller),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar:
          (controller.cartItems.isNotEmpty || controller.summary != null)
          ? _buildCheckoutButton(context, controller)
          : null,
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some items to get started!',
            style: TextStyle(fontSize: 15, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.go('/bottombar');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          /// CART ITEMS
          if (controller.cartItems.isNotEmpty)
            ...controller.cartItems.map((item) => CartItemCard(item: item)),

          const SizedBox(height: 24),

          /// BILL SUMMARY
          if (controller.summary != null)
            _buildBillSummary(context, controller)
          else
            const Center(child: CircularProgressIndicator()),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildBillSummary(BuildContext context, CartController controller) {
    if (controller.summary == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            'Bill Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildBillRow('Subtotal', controller.subtotal),
          const SizedBox(height: 12),

          _buildBillRow('Delivery Fee', controller.deliveryFee),
          const SizedBox(height: 12),

          if (controller.discount > 0) ...[
            _buildBillRow(
              'Discount',
              -controller.discount,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
          ],

          const Divider(),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${controller.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, double amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${controller.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showCheckoutBottomSheet(context, controller);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart?'),
        content: const Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearCart();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }



  void _showCheckoutBottomSheet(
    BuildContext context,
    CartController controller,
  ) {
    final addressCtrl = TextEditingController(text: controller.deliveryAddress);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Order Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (controller.summary == null)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else ...[
                  ...controller.summary!.items.map(
                    (e) => _summaryRow("${e.productName} x${e.qty}", e.amount),
                  ),

                  const Divider(height: 30),
                  _summaryRow("Subtotal", controller.subtotal),
                  _summaryRow("Delivery", controller.deliveryFee),
                  _summaryRow("Discount", -controller.discount),
                  const Divider(height: 30),
                  _summaryRow("Total", controller.total, isBold: true),
                ],

                const SizedBox(height: 24),

                const Text(
                  "Delivery Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: addressCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Enter delivery address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: () {
                        addressCtrl.text = "Vikas Khand, Gomtinagar, Jaipur";
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Delivery Slot",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Payment Method",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                RadioListTile(
                  value: "COD",
                  groupValue: controller.paymentMethod,
                  onChanged: (val) {
                    controller.paymentMethod = val!;
                    controller.notifyListeners();
                  },
                  title: const Text("Cash on Delivery"),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await controller.placeOrder();

                      if (success) {
                        if (context.canPop()) {
                          Navigator.pop(context);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Order placed successfully"),
                          ),
                        );
Navigator.push(context, MaterialPageRoute(builder: (context)=>MainWrapperScreen()));
                        // context.go('/bottombar');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm Order",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "₹${value.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Cart Item Card Widget
class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.network(
                item.productImage,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.local_drink,
                    size: 50,
                    color: Color(0xFF4A90E2),
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
                  item.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.unit,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<CartController>().decreaseQuantity(item.id);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<CartController>().increaseQuantity(item.id);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  context.read<CartController>().removeItem(item.id);
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
