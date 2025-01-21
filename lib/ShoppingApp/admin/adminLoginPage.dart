import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/admin/adminHomePage.dart';
import 'package:phoneauth/ShoppingApp/pages/loginPage.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';

class adminLoginPage extends StatefulWidget {
  const adminLoginPage({super.key});

  @override
  State<adminLoginPage> createState() => _adminLoginPageState();
}

class _adminLoginPageState extends State<adminLoginPage> {
  bool isloading = false;
  bool isPasswordVisible = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset('images/loginOne.png')),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Admin Panel',
                  style: appWidget.semiBoldTextFieldStyle(),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Username',
                style: appWidget.lightBoldTextFieldStyle(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFF4F5F9),
                ),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black38),
                      hintText: 'Enter Name',
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Password',
                style: appWidget.lightBoldTextFieldStyle(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFF4F5F9),
                ),
                child: TextFormField(
                  obscureText: !isPasswordVisible, // Toggle visibility here
                  controller: userPasswordController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.black38),
                    hintText: 'Password',
                    border: InputBorder.none,
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
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isloading = true;
                    });
                    loginadmin();
                    setState(() {
                      isloading = false;
                    });
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
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginadmin() {
    FirebaseFirestore.instance.collection('Admin').get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['username'] != usernameController.text.trim()) {
          ScaffoldMessenger(
              child: SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Your ID is not correct'),
          ));
        } else if (result.data()['password'] !=
            userPasswordController.text.trim()) {
          ScaffoldMessenger(
              child: SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Your Password is not correct'),
          ));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => adminHomePage()));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blue,
              content: Text(
                'Log In Successfully',
                style: TextStyle(fontSize: 20),
              )));
        }
      });
    });
  }
}
