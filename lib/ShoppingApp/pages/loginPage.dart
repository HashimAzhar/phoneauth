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
  String email = '', password = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordVisible = false;

  // Function to fetch user details by email from Firestore and save to SharedPreferences
  Future<void> fetchAndSaveUserDetailsByEmail(String email) async {
    try {
      print("Fetching details for email: $email");

      // Query Firestore for user details by email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Userss')
          .where('Email', isEqualTo: email)
          .get();

      print("Query result: ${querySnapshot.docs.length} documents found.");

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first matching document
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Extract user data
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          // Save details in SharedPreferences
          await sharedPreferenceHelper().saveUserName(userData['Name']);
          await sharedPreferenceHelper().saveUserEmail(userData['Email']);
          await sharedPreferenceHelper().saveUserImage(userData['Image']);
          print("User details saved successfully.");
        } else {
          print("User data is null.");
        }
      } else {
        print("No user found with the provided email.");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'No user found with the provided email.',
              style: TextStyle(fontSize: 16),
            )));
      }
    } catch (e) {
      print("Error fetching user details: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Error fetching user details.',
            style: TextStyle(fontSize: 16),
          )));
    }
  }

  // User login method
  Future<void> userLogin() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Sign in with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print("User logged in: ${userCredential.user?.email}");

      // Fetch and save user details after successful login
      await fetchAndSaveUserDetailsByEmail(email);

      // Navigate to the home page
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => bottomNav()));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            'Login Successfully',
            style: TextStyle(fontSize: 20),
          )));
    } on FirebaseAuthException catch (e) {
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
      print("Error during login: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
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
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'To Proceed, Please Enter Your \n              Details Below',
                    style: appWidget.lightTextFieldStyle(),
                  ),
                ),
                SizedBox(height: 40),
                Text('Email', style: appWidget.semiBoldTextFieldStyle()),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF4F5F9),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Enter Email', border: InputBorder.none),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your email'
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                Text('Password', style: appWidget.semiBoldTextFieldStyle()),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF4F5F9),
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
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
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your password'
                        : null,
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text.trim();
                          password = passwordController.text.trim();
                        });
                        userLogin();
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
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
                SizedBox(height: 20),
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
