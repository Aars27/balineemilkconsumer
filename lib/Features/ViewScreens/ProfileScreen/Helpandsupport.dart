import 'package:consumerbalinee/Core/Constant/app_colors.dart';
import 'package:flutter/material.dart';

// Assuming AppColors is in the same relative path or accessible
// import 'package:your_project/Core/Constant/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // Helper widget for support tiles
  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Background Vector Image at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Vector.png'), // Must exist in assets folder
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Text(
                      'Help & Support',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),

                  // Main Content Box
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                        _buildSupportTile(
                          icon: Icons.question_answer_outlined,
                          title: 'Frequently Asked Questions (FAQ)',
                          onTap: () {
                            // TODO: Implement navigation to FAQ screen
                          },
                        ),
                        const Divider(height: 1),
                        _buildSupportTile(
                          icon: Icons.support_agent_outlined,
                          title: 'Contact Customer Service',
                          onTap: () {
                            // TODO: Implement direct contact/chat feature
                          },
                        ),
                        const Divider(height: 1),
                        _buildSupportTile(
                          icon: Icons.receipt_long_outlined,
                          title: 'Terms of Service',
                          onTap: () {
                            // TODO: Implement navigation to Terms screen
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Quick Contact Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need Immediate Help?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.phone_outlined, color: Colors.green),
                                const SizedBox(width: 10),
                                const Expanded(child: Text('Call Us: +91 98765 43210')),
                                IconButton(
                                  icon: const Icon(Icons.call),
                                  onPressed: () {
                                    // TODO: Implement phone call launch
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}