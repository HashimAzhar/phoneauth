import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:phoneauth/ui/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const splashScreen(),
    );
  }
}
