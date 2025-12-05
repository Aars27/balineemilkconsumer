import 'package:flutter/material.dart';
// Assuming these are defined in your project
import 'package:consumerbalinee/Core/Constant/app_colors.dart';
import 'package:consumerbalinee/Core/Constant/text_constants.dart';

// --- MOCK DATA STRUCTURES ---

class DeliveryInfo {
  final String date;
  final String item;
  final double quantity;

  DeliveryInfo(this.date, this.item, this.quantity);
}

class DashboardScreen extends StatelessWidget {
 DashboardScreen({super.key});

  // Mock data for demonstration
  final String userName = "Aman Sharma";
  final DeliveryInfo nextDelivery = DeliveryInfo("Tomorrow, 6:00 AM", "Cow Milk (A2)", 1.0);
  final double walletBalance = 450.75;

  // List of items in the current subscription
  final List<DeliveryInfo> subscriptions = [
    DeliveryInfo("Daily", "Cow Milk (A2)", 1.0),
    DeliveryInfo("Every Sat/Sun", "Curd 500g", 1.0),
    DeliveryInfo("Every Tue/Fri", "Paneer 200g", 0.5),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey, // A soft background color

      appBar: _buildAppBar(context),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Next Delivery Card (Prominent Header)
            _buildNextDeliveryCard(),

            const SizedBox(height: 16),

            // 2. Quick Action/Wallet Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildWalletCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickActionCard(context)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Subscription Overview Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "My Current Subscription",
                style: TextConstants.headingStyle.copyWith(fontSize: 18, color: AppColors.advanceColor),
              ),
            ),
            const SizedBox(height: 12),

            // 4. Subscription List
            ...subscriptions.map((sub) => _buildSubscriptionTile(sub)).toList(),

            const SizedBox(height: 24),

            // 5. Promotional Banners (The beautiful UI element)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Special Offers for You",
                style: TextConstants.headingStyle.copyWith(fontSize: 18, color: Colors.red),
              ),
            ),
            const SizedBox(height: 12),
            _buildBanners(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.logincolor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome Back,", style: TextConstants.smallTextStyle.copyWith(color: AppColors.white.withOpacity(0.8))),
          Text(userName, style: TextConstants.headingStyle.copyWith(color: AppColors.white, fontSize: 24)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: AppColors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.account_circle, color: AppColors.white),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(16.0),
        child: Container(),
      ),
    );
  }

  Widget _buildNextDeliveryCard() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.logincolor, // Use an accent color for emphasis
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Next Delivery",
            style: TextConstants.smallTextStyle.copyWith(color: AppColors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextDelivery.date,
                    style: TextConstants.headingStyle.copyWith(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${nextDelivery.quantity.toStringAsFixed(1)} Ltr of ${nextDelivery.item}",
                    style: TextConstants.smallTextStyle.copyWith(color: AppColors.white),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Modify"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.logincolor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.logincolor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_balance_wallet_outlined, color: AppColors.logincolor),
          const SizedBox(height: 8),
          Text("Wallet Balance", style: TextConstants.smallTextStyle.copyWith(color: AppColors.grey)),
          Text(
            "₹${walletBalance.toStringAsFixed(2)}",
            style: TextConstants.headingStyle.copyWith(color: AppColors.logincolor, fontSize: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.logincolor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.logincolor.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to Add/Pause screen
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.pause_circle_outline, color: AppColors.logincolor),
            const SizedBox(height: 8),
            Text("Need a break?", style: TextConstants.smallTextStyle.copyWith(color: AppColors.grey)),
            Text(
              "Pause Delivery",
              style: TextConstants.headingStyle.copyWith(color: AppColors.logincolor, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionTile(DeliveryInfo sub) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.logincolor),
      ),
      child: Row(
        children: [
          Icon(
            sub.item.contains("Milk") ? Icons.local_drink : Icons.shopping_basket,
            color: AppColors.logincolor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.item,
                  style: TextConstants.headingStyle.copyWith(fontSize: 16),
                ),
                Text(
                  sub.date,
                  style: TextConstants.smallTextStyle.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          Text(
            "${sub.quantity} ${sub.item.contains("Milk") ? 'Ltr' : 'Pcs'}",
            style: TextConstants.headingStyle.copyWith(color: AppColors.logincolor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBanners() {
    return SizedBox(
      height: 150, // Fixed height for the banner area
      child: PageView(
        controller: PageController(viewportFraction: 0.9), // Show a bit of the next banner
        children: [
          _buildBannerItem(
            color: const Color(0xFFFDD835), // Yellow
            title: "50% Off on First Cheese Order!",
            subtitle: "Try our artisanal cheese range.",
            icon: Icons.local_dining,
          ),
          _buildBannerItem(
            color: const Color(0xFFC8E6C9), // Light Green
            title: "Refer & Earn",
            subtitle: "Invite a friend and get ₹100 credit.",
            icon: Icons.person_add_alt_1,
          ),
          _buildBannerItem(
            color: const Color(0xFFBBDEFB), // Light Blue
            title: "Premium Desi Ghee",
            subtitle: "Limited stock available. Shop now!",
            icon: Icons.star,
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem({
    required Color color,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: AppColors.logincolor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextConstants.headingStyle.copyWith(fontSize: 16, color: AppColors.logincolor, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextConstants.smallTextStyle.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}