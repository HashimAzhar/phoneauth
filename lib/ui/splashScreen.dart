import 'package:flutter/material.dart';
import 'package:phoneauth/fireBaseServices/splashServices.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  splashServices splashServicess = splashServices();

  @override
  void initState() {
    super.initState();
    splashServicess.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Color(0xfff2f2f2), // Background color
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo with responsive width and height
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(20), // Rounded corners for logo
              child: Image.asset(
                'images/shopfinityw.jpg',
                width: screenWidth * 0.7, // 50% of screen width
                height: screenWidth * 0.7, // 50% of screen width
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
                height:
                    screenHeight * 0.03), // Adjusted space for better scaling
            // Stylized text with smooth font and responsive size
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Fast, Simple, and Secure \nShopping Experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Better text color for visibility
                  letterSpacing: 1.5,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
                height:
                    screenHeight * 0.05), // Adjusted space for better scaling
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
