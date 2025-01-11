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
  @override
  void initState() {
    // TODO: implement initState
    homeePage = homePage();
    orderrPage = orderPage();
    profileePage = profilePage();
    pages = [homeePage, orderrPage, profileePage];
    super.initState();
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
            setState(() {
              currentTabIndex = index;
            });
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
