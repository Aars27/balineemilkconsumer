// Inside OnboardingController.dart (or equivalent)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../OnboardingModal/onboarding_modal.dart';

class OnboardingController extends ChangeNotifier {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;

  // Your list of pages (OnboardingPageModel)
  final List<OnboardingModel> pages = [

    OnboardingModel(
      image: 'assets/onboarding1.gif',
      title: 'Fresh Milk, Every Morning',
      description: 'Subscribe once and get the freshest milk and daily essentials delivered right to your doorstep.',
    ),
    OnboardingModel(
      image: 'assets/gif.gif',
      title: 'Pause or Modify Anytime',
      description: 'Easily pause, reschedule, or change your order quantity from the app with just a few taps.',
    ),
  ];



  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }
  }
}