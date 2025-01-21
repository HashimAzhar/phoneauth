import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/pages/bottomNav.dart';
import 'package:phoneauth/ShoppingApp/pages/loginPage.dart';
import 'package:phoneauth/ShoppingApp/services/database.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';

class signUPPage extends StatefulWidget {
  const signUPPage({super.key});

  @override
  State<signUPPage> createState() => _signUPPageState();
}

class _signUPPageState extends State<signUPPage> {
  final _formkey = GlobalKey<FormState>();
  String? Name, Email, Password;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isloading = false;
  bool isPasswordVisible = false;

  Future<void> registration() async {
    try {
      setState(() {
        isloading = true;
      });

      if (Name != null && Email != null && Password != null) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: Email!, password: Password!);

        // Registration successful snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            'Registered Successfully',
            style: TextStyle(fontSize: 20),
          ),
        ));

        String Id = DateTime.now().millisecondsSinceEpoch.toString();
        await sharedPreferenceHelper().saveUserId(Id);
        await sharedPreferenceHelper().saveUserName(nameController.text);
        await sharedPreferenceHelper().saveUserEmail(emailController.text);
        await sharedPreferenceHelper().saveUserImage(
            'https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes-thumbnail.png');

        Map<String, dynamic> userInfoMap = {
          'Name ': nameController.text,
          'Email': emailController.text,
          'Id': Id,
          'Image':
              'https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes-thumbnail.png'
        };

        await databaseMethods().HashimAddUserDetails(userInfoMap, Id);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const bottomNav(),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Please fill out all the fields.',
            style: TextStyle(fontSize: 20),
          ),
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Password provided is too weak.',
            style: TextStyle(fontSize: 20),
          ),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Account already exists.',
            style: TextStyle(fontSize: 20),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Registration failed: ${e.message}',
            style: TextStyle(fontSize: 20),
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          'An unexpected error occurred. Please try again later.',
          style: TextStyle(fontSize: 20),
        ),
      ));
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset('images/loginOne.png')),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Sign Up',
                    style: appWidget.semiBoldTextFieldStyle(),
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: Text(
                    'To Proceed, Please Enter Your \n              Details Below',
                    style: appWidget.lightTextFieldStyle(),
                  ),
                ),
                SizedBox(height: 10),
                Text('Name', style: appWidget.lightBoldTextFieldStyle()),
                SizedBox(height: 10),
                _buildTextField(nameController, 'Enter Name'),
                SizedBox(height: 10),
                Text('Email', style: appWidget.lightBoldTextFieldStyle()),
                SizedBox(height: 10),
                _buildTextField(emailController, 'Enter Email'),
                SizedBox(height: 10),
                Text('Password', style: appWidget.lightBoldTextFieldStyle()),
                SizedBox(height: 10),
                _buildPasswordField(),
                SizedBox(height: 15),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          Name = nameController.text;
                          Email = emailController.text;
                          Password = passwordController.text;
                        });
                        registration();
                      }
                    },
                    child: isloading
                        ? CircularProgressIndicator()
                        : _buildSignUpButton(),
                  ),
                ),
                SizedBox(height: 20),
                _buildLoginPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF4F5F9),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $hintText';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.black38),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF4F5F9),
      ),
      child: TextFormField(
        obscureText: !isPasswordVisible,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        controller: passwordController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.black38),
          hintText: 'Password',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
      ),
      child: Center(
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: appWidget.lightTextFieldStyle(),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => loginPage()));
          },
          child: Text(
            'Log In',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
