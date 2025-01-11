import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoneauth/ShoppingApp/admin/adminLoginPage.dart';
import 'package:phoneauth/ShoppingApp/pages/loginPage.dart';
import 'package:phoneauth/ShoppingApp/pages/onBoardingPage.dart';
import 'package:phoneauth/ShoppingApp/services/auth.dart';
import 'package:phoneauth/ShoppingApp/services/database.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String? image, name, email;
  getTheSharedPref() async {
    final fetchedImage = await sharedPreferenceHelper().getUserImage();
    final fetchedName = await sharedPreferenceHelper().getUserName();
    final fetchedEmail = await sharedPreferenceHelper().getUserEmail();

    setState(() {
      image = fetchedImage;
      name = fetchedName;
      email = fetchedEmail;
    });
  }

  @override
  void initState() {
    getTheSharedPref();
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
    uploadItem();
  }

  Future<void> clearUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('blogImage').child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadURL = await (await task).ref.getDownloadURL();
      await sharedPreferenceHelper().saveUserImage(downloadURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: Text(
          'Profile',
          style: appWidget.boldTextFieldStyle(),
        ),
      ),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: [
                  selectedImage != null
                      ? GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(
                                selectedImage!,
                                height: 110,
                                width: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(
                                image!,
                                height: 110,
                                width: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 3,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outlined,
                              color: Colors.black,
                              size: 35,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: appWidget.lightTextFieldStyle(),
                                ),
                                Text(
                                  name!,
                                  style: appWidget.semiBoldTextFieldStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 3,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              color: Colors.black,
                              size: 35,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: appWidget.lightTextFieldStyle(),
                                ),
                                Text(
                                  email!,
                                  style: appWidget.semiBoldTextFieldStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Clear user preferences before logging out
                      await clearUserPreferences();
                      await authMethods().signOut().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginPage()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: Colors.black,
                                size: 35,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'LogOut',
                                style: appWidget.semiBoldTextFieldStyle(),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Clear user preferences before deleting the account
                      await clearUserPreferences();
                      await authMethods().deleteAccount().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => onBoarding()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.black,
                                size: 35,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Delete Account',
                                style: appWidget.semiBoldTextFieldStyle(),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => adminLoginPage()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Icon(
                                Icons.admin_panel_settings_outlined,
                                color: Colors.black,
                                size: 35,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Admin Panel',
                                style: appWidget.semiBoldTextFieldStyle(),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
