import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:phoneauth/ShoppingApp/admin/adProductPagee.dart';
import 'package:phoneauth/ShoppingApp/admin/adminHomePage.dart';

import 'package:phoneauth/ShoppingApp/admin/adminLoginPage.dart';
import 'package:phoneauth/ShoppingApp/admin/allOrders.dart';
import 'package:phoneauth/ShoppingApp/pages/bottomNav.dart';
import 'package:phoneauth/ShoppingApp/pages/homePage.dart';
import 'package:phoneauth/ShoppingApp/pages/loginPage.dart';
import 'package:phoneauth/ShoppingApp/pages/onBoardingPage.dart';
import 'package:phoneauth/ShoppingApp/pages/productDetailPage.dart';
import 'package:phoneauth/ShoppingApp/pages/productsCategory.dart';
import 'package:phoneauth/ShoppingApp/services/constant.dart';
import 'package:phoneauth/ui/auth/signUpScreen.dart';
import 'package:phoneauth/ui/fireStore/firestoreListScreen.dart';

import 'package:phoneauth/ui/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryTextTheme: Typography.whiteMountainView,
        iconButtonTheme: const IconButtonThemeData(),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set all icons to white by default
        ),
        appBarTheme: const AppBarTheme(
            color: Colors.deepPurple,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true, // Set back arrow color to white
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
      home: loginPage(),
    );
  }
}
