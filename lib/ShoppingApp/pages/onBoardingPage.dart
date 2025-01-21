import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/pages/loginPage.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 235, 231),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:
                    screenHeight * 0.4, // Use a percentage of the screen height
                child: Image.asset(
                  "images/headphone.PNG",
                  fit: BoxFit.contain,
                  width: double.infinity, // Make the image adapt to the width
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Explore\nThe Best\nProducts',
                style: TextStyle(
                  fontSize: screenWidth *
                      0.15, // Use a percentage of the screen width
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(), // Push content to the top and button to the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => loginPage()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.all(screenWidth * 0.05), // Dynamic padding
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: screenWidth * 0.10, // Dynamic font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
