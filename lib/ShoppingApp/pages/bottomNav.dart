import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/pages/homePage.dart';
import 'package:phoneauth/ShoppingApp/pages/orderPage.dart';
import 'package:phoneauth/ShoppingApp/pages/profilePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class bottomNav extends StatefulWidget {
  const bottomNav({super.key, String? userName, String? userImage});

  @override
  State<bottomNav> createState() => _bottomNavState();
}

class _bottomNavState extends State<bottomNav> {
  late List<Widget> pages;
  late homePage homeePage;
  late orderPage orderrPage;
  late profilePage profileePage;
  int currentTabIndex = 0;

  bool _isUploading = false; // Track the upload status

  // Method to disable navigation
  void startImageUpload() {
    setState(() {
      _isUploading = true;
    });
  }

  // Method to enable navigation
  void finishImageUpload() {
    setState(() {
      _isUploading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    homeePage = homePage();
    orderrPage = orderPage();

    // Pass valid callbacks to profilePage
    profileePage = profilePage(
        onImageUpload: startImageUpload,
        onImageUploadFinish: finishImageUpload);
    pages = [homeePage, orderrPage, profileePage];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Color(0xfff2f2f2),
          color: Colors.black,
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            if (!_isUploading) {
              setState(() {
                currentTabIndex = index;
              });
            }
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.person_outlined,
              color: Colors.white,
            ),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
