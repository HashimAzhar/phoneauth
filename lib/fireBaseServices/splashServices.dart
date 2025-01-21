import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/pages/bottomNav.dart';
import 'package:phoneauth/ShoppingApp/pages/loginPage.dart';
import 'package:phoneauth/ShoppingApp/pages/onBoardingPage.dart';
import 'package:phoneauth/ui/auth/loginScreen.dart';
import 'package:phoneauth/ui/fireStore/firestoreListScreen.dart';
import 'package:phoneauth/ui/posts/postScreen.dart';
import 'dart:async';

import 'package:phoneauth/ui/uploadImageScreen.dart';

class splashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => bottomNav()),
                // MaterialPageRoute(
                //     builder: (context) => const uploadImageScreen()),
              ));
    } else {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => onBoarding())),
      );
    }
  }
}
