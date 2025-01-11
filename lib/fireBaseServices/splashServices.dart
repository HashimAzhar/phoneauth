// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:phoneauth/ui/auth/loginScreen.dart';
// import 'package:phoneauth/ui/fireStore/firestoreListScreen.dart';
// import 'package:phoneauth/ui/posts/postScreen.dart';
// import 'dart:async';

// import 'package:phoneauth/ui/uploadImageScreen.dart';

// class splashServices {
//   void isLogin(BuildContext context) {
//     final auth = FirebaseAuth.instance;

//     final user = auth.currentUser;
//     if (user != null) {
//       Timer(
//           const Duration(seconds: 3),
//           () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const postScreen()),
//                 // MaterialPageRoute(
//                 //     builder: (context) => const uploadImageScreen()),
//               ));
//     } else {
//       Timer(
//         const Duration(seconds: 3),
//         () => Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const loginScreen())),
//       );
//     }
//   }
// }
