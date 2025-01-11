import 'package:firebase_auth/firebase_auth.dart';

class authMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}
