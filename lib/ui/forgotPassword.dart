import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/fireBaseServices/widgets/roundButton.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class ForgotpasswordSceen extends StatefulWidget {
  const ForgotpasswordSceen({super.key});

  @override
  State<ForgotpasswordSceen> createState() => _ForgotpasswordSceenState();
}

class _ForgotpasswordSceenState extends State<ForgotpasswordSceen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: ('Email'),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            roundButton(
                title: 'Forgot',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('We have a recovery email to you');
                  }).onError((error, StackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
