import 'package:flutter/material.dart';
import 'login_signup_screen.dart'; // Import your login/signup screen

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

/*class OnboardingPageData {
  final String image;
  final String text;

  OnboardingPageData({required this.image, required this.text});
}

 */


class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding pages content

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/image1.png", // Add your image assets
      "text": "Welcome to WeMeet!! Connect with friends,discover your desire K-pop group!💜",
    },
    {
      "image": "assets/image2.png",
      "text": "Mindblowing and great Experience, share idea and stay updated!!⭐",
    },
    {
      "image": "assets/image3.png",
      "text": "Let's Get Started on Your Journey! 🦋",
    },
  ];

//data clumpes
  /*final List<OnboardingPageData> onboardingPages = [
    OnboardingPageData(
      image: "assets/image1.png",
      text: "Welcome to WeMeet!! Connect with friends...",
    ),
    OnboardingPageData(
      image: "assets/image2.png",
      text: "Mindblowing and great Experience...",
    ),
  ];

   */
  // Navigate to Login/Signup screen
  void _goToLoginScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginSignupScreen(),
        transitionDuration: Duration.zero, // No delay at all
        reverseTransitionDuration: Duration.zero, // No reverse animation delay
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return _buildOnboardingPage(
                  image: onboardingData[index]["image"]!,
                  text: onboardingData[index]["text"]!,
                );
              },
            ),
          ),
          _buildDotsIndicator(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  // Onboarding Page UI
  Widget _buildOnboardingPage({required String image, required String text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Image.asset(image, height: 300), // Image
        ),
        SizedBox(height: 20),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifico', // Use a fancy font
            ),
          ),
        ),
      ],
    );
  }

  // Dots Indicator
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
            (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 20 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Bottom Navigation Buttons
  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage < 2)
            TextButton(
              onPressed: _goToLoginScreen, // Skip Button
              child: Text(
                "Skip",
                style: TextStyle(fontSize: 18, fontFamily: 'DancingScript'),
              ),
            ),
          if (_currentPage == 2)
            ElevatedButton(
              onPressed: _goToLoginScreen, // Get Started Button
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Get Started",
                style: TextStyle(fontSize: 18, fontFamily: 'Pacifico'),
              ),
            ),
        ],
      ),
    );
  }
}


