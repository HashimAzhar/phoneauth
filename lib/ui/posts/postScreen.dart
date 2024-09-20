import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneauth/ui/auth/loginScreen.dart';
import 'package:phoneauth/ui/posts/addPost.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class postScreen extends StatefulWidget {
  const postScreen({super.key});

  @override
  State<postScreen> createState() => _postScreenState();
}

class _postScreenState extends State<postScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Post Screen'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const loginScreen()));
                    }).onError((error, StackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  icon: const Icon(Icons.logout_outlined))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addPostScreen()));
            },
            child: Icon(Icons.add),
          )),
    );
  }
}
