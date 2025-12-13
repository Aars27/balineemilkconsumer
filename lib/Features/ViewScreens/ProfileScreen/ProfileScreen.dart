import 'package:consumerbalinee/Features/ViewScreens/DailyOrderScreen/DailyOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Components/Savetoken/utils_local_storage.dart';
import '../../../Core/Constant/app_colors.dart'; // Ensure this path is correct

// Import the new screens
import '../../NotificationScreen/NotificationScreen.dart';
import 'EditScreen.dart' hide AppColors;
import 'Helpandsupport.dart';
import 'PrivacyPolicy.dart';


class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  bool _notificationsEnabled = true;
  // State for the milk-related update point
  String _milkProfileStatus = 'Basic Milk Plan';

  String _userName = "Guest User";
  String _userType = "Basic Milk Plan";


  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final user = await LocalStorage.getUserData();

    if (user != null) {
      setState(() {
        _userName = user.fullName.isNotEmpty ? user.fullName : "Guest User";
        _userType = user.userType ?? "Basic Milk Plan";
      });
    }
  }



  // Helper function for navigation
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Background Vector Image at top
          //
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Vector.png'), // Assumes 'assets/Vector.png' exists
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 24,
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

                  // User Profile Card
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 60),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradientEnd.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  _userName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Milk Profile Update Point
                                Text(
                                    _userType,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Menu Items
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      children: [
                        _buildMenuItem(
                          icon: Icons.shopping_bag_outlined,
                          iconColor:AppColors.gradientEnd,
                          title: 'My Daily Orders',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Dailyorderscreen()));
                          }, // Add navigation here if needed
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.edit_outlined,
                          iconColor: AppColors.gradientEnd,
                          title: 'Edit Profile',
                          onTap: () => _navigateTo(context, const EditProfileScreen()),
                        ),
                        _buildDivider(),
                        // Help & Support with onTap
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          iconColor: AppColors.gradientEnd,
                          title: 'Help & Support',
                          onTap: () => _navigateTo(context, const HelpSupportScreen()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Account Settings Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),

                  // Settings Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      children: [
                        _buildSettingItem(
                          title: 'Notifications',
                          trailing: Switch(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                            activeThumbColor: AppColors.gradientEnd,
                          ),
                        ),
                        _buildDivider(),
                        // Privacy Policy with onTap
                        _buildSettingItem(
                          title: 'Privacy Policy',
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                          onTap: () => _navigateTo(context, const PrivacyPolicyScreen()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App Version & Logo
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style : ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async{
                              await LocalStorage.clearAll();

                              if (!context.mounted) return;

                              context.go('/loginpage'); // Redirect to login screen
                            },
                            child: const Text( // Added const for better performance
                              'Logout',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets (Unchanged)
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemWithBadge({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String badge,
    required VoidCallback onTap,
  }) {
    // This widget is not currently used but remains in the code
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gradientEnd,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: Colors.grey[200],
      ),
    );
  }
}