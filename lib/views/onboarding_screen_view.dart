import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'login_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  bool isFirstPage = true;
  final Color primaryColor = const Color(0xFF565657);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
                isFirstPage = index == 0;
              });
            },
            children: [
              _buildPage(
                title: 'Effortless Order Management',
                description:
                    'Quickly input and track customer orders in real time.',
                image: 'assets/images/management.gif',
              ),
              _buildPage(
                title: 'Monitor Inventory & Sales',
                description:
                    'Monitor stock and sales with detailed records for smarter decisions.',
                image: 'assets/images/Inventory.gif',
              ),
              _buildPage(
                title: 'Secure Payments & Insights',
                description:
                    'Quick payments with insights to boost performance.',
                image: 'assets/images/QR.gif',
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 20,
            child: _buildSkipButton(),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: isFirstPage
                ? const SizedBox.shrink()
                : _buildButton(Icons.arrow_back_ios, _onPreviousPressed),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const ExpandingDotsEffect(
                    activeDotColor: Color(0xFF565657),
                    dotHeight: 6,
                    dotWidth: 16),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: isLastPage
                ? _buildButton(Icons.check_circle, _onNextPressed)
                : _buildButton(Icons.arrow_forward_ios, _onNextPressed),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
      {required String title,
      required String description,
      required String image}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Image.asset(image, height: 350, fit: BoxFit.cover),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 300,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(0),
        elevation: 0,
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      child: Icon(
        icon,
        color: primaryColor,
        size: 30,
      ),
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: _completeOnboarding,
      child: Text(
        'Skip',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLaunch', false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  void _onPreviousPressed() {
    if (_controller.page! > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onNextPressed() {
    if (isLastPage) {
      _completeOnboarding();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
