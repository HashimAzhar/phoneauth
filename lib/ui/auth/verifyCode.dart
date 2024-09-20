import 'package:flutter/material.dart';

class verifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const verifyCodeScreen({super.key, required this.verificationId});

  @override
  State<verifyCodeScreen> createState() => _verifyCodeScreenState();
}

class _verifyCodeScreenState extends State<verifyCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
