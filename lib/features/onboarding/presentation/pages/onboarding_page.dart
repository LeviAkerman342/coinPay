import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/router/domain/app_routes.dart';
import 'package:myapp/core/storage/app_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      imageAsset: 'assets/1.jpg', 
      title: 'Trusted by millions\nof people, part of\none part',
      subtitle: '', 
    ),
    OnboardingSlide(
      imageAsset: 'assets/1.jpg',
      title: 'Spend money\nabroad, and track\nyour expense',
      subtitle: '',
    ),
    OnboardingSlide(
      imageAsset: 'https://media.gettyimages.com/id/1792400479/vector/store-or-pay-in-usd-using-your-phone.jpg',
      title: 'Receive Money\nFrom Anywhere In\nThe World',
      subtitle: '',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Последний слайд — завершаем онбординг
      AppStorage.completeOnboarding();
      if (mounted) {
        context.go(AppRoutes.login); // переходим на логин
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
         
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  AppStorage.completeOnboarding();
                  context.go(AppRoutes.login);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // PageView с слайдами
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) => _slides[index],
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _slides.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Color(0xFF0066FF),
                      dotColor: Colors.grey,
                      expansionFactor: 4,
                      spacing: 8,
                    ),
                  ),

                  
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}