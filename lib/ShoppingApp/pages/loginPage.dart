import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/pages/bottomNav.dart';
import 'package:phoneauth/ShoppingApp/pages/signUpPage.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String Email = '', Password = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isloading = false;
  bool isPasswordVisible = false;

  // Function to fetch user details from Firestore and save to SharedPreferences
  Future<void> fetchAndSaveUserDetails(String userId) async {
    try {
      // Fetch user details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Userss')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Extract user data
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Save details in SharedPreferences
        await sharedPreferenceHelper().saveUserName(userData['Name']);
        await sharedPreferenceHelper().saveUserEmail(userData['Email']);
        await sharedPreferenceHelper().saveUserImage(userData['Image']);

        print("User details saved successfully.");
      } else {
        print("User document does not exist in Firestore.");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  // User login method
  userLogin() async {
    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: Email, password: Password);

      // Fetch and save user details after successful login
      String userId = userCredential.user!.uid;
      await fetchAndSaveUserDetails(userId);

      // Navigate to the home page
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => bottomNav()));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            'Login Successfully',
            style: TextStyle(fontSize: 20),
          )));
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'No User Found for that Email',
              style: TextStyle(fontSize: 20),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Wrong Password Added by the User',
              style: TextStyle(fontSize: 20),
            )));
      }
    } catch (e) {
      // General error handling
      print("Error during login: $e");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset('images/loginOne.png')),
                Center(
                  child: Text(
                    'Log In',
                    style: appWidget.semiBoldTextFieldStyle(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'To Proceed, Please Enter Your \n              Details Below',
                    style: appWidget.lightTextFieldStyle(),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Email',
                  style: appWidget.semiBoldTextFieldStyle(),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF4F5F9),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ('Please Enter your Email');
                      } else {
                        return null;
                      }
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Enter Email', border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Password',
                  style: appWidget.semiBoldTextFieldStyle(),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF4F5F9),
                  ),
                  child: TextFormField(
                    obscureText: !isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ('Please Enter your Password');
                      } else {
                        return null;
                      }
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        hintText: 'Enter Password',
                        border: InputBorder.none),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          Email = emailController.text;
                          Password = passwordController.text;
                        });
                        setState(() {
                          isloading = true;
                        });
                        userLogin();
                      }
                    },
                    child: isloading
                        ? Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: appWidget.lightTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signUPPage()));
                      },
                      child: Text(
                        'Sign UP',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
