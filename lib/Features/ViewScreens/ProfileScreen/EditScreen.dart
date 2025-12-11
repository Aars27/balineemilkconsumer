import 'package:flutter/material.dart';

import '../../../Core/Constant/app_colors.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers initialized with mock data based on the JSON structure
  final TextEditingController _firstNameController = TextEditingController(text: "Rahul");
  final TextEditingController _lastNameController = TextEditingController(text: "Sharma");
  final TextEditingController _mobileNoController = TextEditingController(text: "9876543220");
  final TextEditingController _emailController = TextEditingController(text: "rahul@gmail.com");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Function to handle the update logic
  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      // 1. Collect updated data
      Map<String, String> updatedData = {
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "mobile_no": _mobileNoController.text,
        "email": _emailController.text,
      };

      // 2. Ideally, send updatedData to a server/database here.

      // 3. Navigate back, passing the updated data to the previous screen (Profilescreen)
      Navigator.pop(context, updatedData);
    }
  }

  // Helper widget for custom text form fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: AppColors.gradienTEnd),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.gradienTStart, width: 2),
          ),
        ),
        validator: validator,
      ),
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
                  image: AssetImage('assets/Vector.png'), // Assumes 'assets/Vector.png' exists
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),

                  // Profile Image Placeholder
                  Center(
                    child: Stack(
                      children: [

                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gradientEnd, width: 3),
                            image: const DecorationImage(
                              // Placeholder image for the user
                              image: AssetImage('assets/milk.gif'),
                              fit: BoxFit.cover,
                            ),
                          ),

                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: AppColors.gradientStart,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Form Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _firstNameController,
                            label: 'First Name',
                            icon: Icons.person_outline,
                            validator: (value) => value!.isEmpty ? 'Please enter your first name' : null,
                          ),
                          _buildTextField(
                            controller: _lastNameController,
                            label: 'Last Name',
                            icon: Icons.person_outline,
                            validator: (value) => value!.isEmpty ? 'Please enter your last name' : null,
                          ),
                          _buildTextField(
                            controller: _mobileNoController,
                            label: 'Mobile Number',
                            icon: Icons.phone_android,
                            keyboardType: TextInputType.phone,
                            validator: (value) => value!.length != 10 ? 'Mobile number must be 10 digits' : null,
                          ),
                          // Email is often read-only for security reasons
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true, // Typically email is not editable
                          ),

                          const SizedBox(height: 20),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gradientStart,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _updateProfile,
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}