import 'package:consumerbalinee/Core/Constant/app_colors.dart';
import 'package:consumerbalinee/Core/Constant/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'OnBoardingController/Onbarding_Controller.dart'; // Assuming this is correct

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the controller for state changes (currentIndex)
    final controller = context.watch<OnboardingController>();
    final isLastPage = controller.currentIndex == controller.pages.length - 1;

    return Scaffold(
      // Use a light, creamy color or white for the background
      backgroundColor: AppColors.white, // Or a light, milky color
      body: Stack(
        children: [
          // 1. PageView - The main content
          PageView.builder(
            controller: controller.pageController, // Use a controller in OnboardingController
            itemCount: controller.pages.length,
            onPageChanged: controller.updateIndex,
            itemBuilder: (context, index) {
              final page = controller.pages[index];
              return Padding(
                padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
                child: Column(
                  // Center content vertically on the screen
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Image/Lottie Animation - More space for the visual
                    Image.asset(
                      page.image,
                      height: MediaQuery.of(context).size.height * 0.40, // Responsive height
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),

                    // Title - Emphasize the message
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: TextConstants.headingStyle.copyWith(
                        color: AppColors.advanceColor, // Use a strong color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: TextConstants.smallTextStyle.copyWith(
                        color: AppColors.grey, // A softer color for body text
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 2. Indicator and Button - Fixed at the bottom
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Indicator Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.pages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: controller.currentIndex == index ? 24 : 8, // Longer when selected
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.currentIndex == index
                            ? AppColors.accentRed // Accent color for selection
                            : AppColors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 56, // Fixed height for a prominent button
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLastPage) {
                        // Navigate to home/sign-up screen
                       context.go('/loginpage');
                      } else {
                        // Go to the next page smoothly
                        controller.nextPage();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.advanceColor, // Primary brand color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLastPage ? "Get Started" : "Next", // Dynamic button text
                      style: TextConstants.smallTextStyle.copyWith(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}