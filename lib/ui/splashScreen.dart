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
    // TODO: implement initState
    super.initState();
    splashServicess.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Firebase tutorial',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
