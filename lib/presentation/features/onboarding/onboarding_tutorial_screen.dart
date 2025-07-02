import 'package:flutter/material.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:dishtv_agent_tracker/core/constants/app_colors.dart';

class OnboardingTutorialScreen extends StatefulWidget {
  const OnboardingTutorialScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingTutorialScreen> createState() => _OnboardingTutorialScreenState();
}

class _OnboardingTutorialScreenState extends State<OnboardingTutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'title': 'Welcome to DishTV Agent Tracker!',
      'description': 'This app helps you track your daily calls, login time, and salary. Let's get started!',
      'image': Icons.waving_hand,
    },
    {
      'title': 'Add Your Daily Entry',
      'description': 'Tap the "+" button on the dashboard to add your daily call count and login time.',
      'image': Icons.add_circle_outline,
    },
    {
      'title': 'View Monthly Performance',
      'description': 'Swipe left/right on the dashboard or use the "Monthly" tab to see your monthly reports.',
      'image': Icons.bar_chart,
    },
    {
      'title': 'Export Reports',
      'description': 'Go to the "All Reports" section and tap "Export PDF" to save your reports.',
      'image': Icons.picture_as_pdf,
    },
    {
      'title': 'Understand Salary Calculation',
      'description': 'Salary is calculated based on your call count and login time. Check the FAQ for details.',
      'image': Icons.calculate,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Onboarding Tutorial'),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingPages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _onboardingPages[index]['image'] as IconData,
                        size: 100,
                        color: AppColors.dishTvOrange,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        _onboardingPages[index]['title'] as String,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dishTvOrange,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _onboardingPages[index]['description'] as String,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildPageIndicator(),
          _buildNavigationButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingPages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 10,
          width: _currentPage == index ? 30 : 10,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.dishTvOrange : Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: const Text('Previous'),
            ),
          const Spacer(),
          if (_currentPage < _onboardingPages.length - 1)
            ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: const Text('Next'),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Or navigate to home screen
              },
              child: const Text('Finish'),
            ),
        ],
      ),
    );
  }
}
