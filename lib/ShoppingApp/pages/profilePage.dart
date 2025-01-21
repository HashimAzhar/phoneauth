import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoneauth/ShoppingApp/admin/adminLoginPage.dart';
import 'package:phoneauth/ShoppingApp/pages/loginPage.dart';
import 'package:phoneauth/ShoppingApp/pages/onBoardingPage.dart';
import 'package:phoneauth/ShoppingApp/services/auth.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilePage extends StatefulWidget {
  final VoidCallback onImageUpload;
  final VoidCallback onImageUploadFinish;

  const profilePage({
    super.key,
    required this.onImageUpload,
    required this.onImageUploadFinish,
  });

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String? image, name, email;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false; // Track upload status

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
  }

  Future<void> getTheSharedPref() async {
    final fetchedImage = await sharedPreferenceHelper().getUserImage();
    final fetchedName = await sharedPreferenceHelper().getUserName();
    final fetchedEmail = await sharedPreferenceHelper().getUserEmail();

    setState(() {
      image = fetchedImage;
      name = fetchedName;
      email = fetchedEmail;
    });
  }

  Future<void> showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Update'),
        content: Text('Do you want to update your profile picture?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              await uploadItem(); // Proceed with image upload
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> uploadItem() async {
    if (selectedImage != null) {
      try {
        setState(() {
          isUploading = true;
        });
        widget.onImageUpload(); // Disable bottom nav while uploading

        String addId = randomAlphaNumeric(10);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('profileImages').child(addId);
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
        var downloadURL = await (await task).ref.getDownloadURL();

        await sharedPreferenceHelper().saveUserImage(downloadURL);

        await FirebaseFirestore.instance
            .collection('Userss')
            .where('Email', isEqualTo: email) // Match the user's email
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            querySnapshot.docs.first.reference.update({'Image': downloadURL});
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully!')),
        );

        widget.onImageUploadFinish();
        setState(() {
          isUploading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile picture: $e')),
        );
        widget.onImageUploadFinish();
        setState(() {
          isUploading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected!')),
      );
    }
  }

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });

      showConfirmationDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  Future<void> clearUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                isUploading
                    ? Center(child: CircularProgressIndicator())
                    : GestureDetector(
                        onTap: getImage,
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4.0,
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: selectedImage != null
                                      ? Image.file(
                                          selectedImage!,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          image!,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: -10,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                profileField(Icons.person_outlined, 'Name', name!),
                SizedBox(height: 20),
                profileField(Icons.mail_outline, 'Email', email!),
                SizedBox(height: 20),
                logoutButton(context),
                SizedBox(height: 20),
                deleteAccountButton(context),
                SizedBox(height: 20),
                adminPanelButton(context),
              ],
            ),
    );
  }

  Widget profileField(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(icon, color: Colors.black, size: 35),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: appWidget.lightTextFieldStyle()),
                  Text(value, style: appWidget.semiBoldTextFieldStyle()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await clearUserPreferences();
        await authMethods().signOut().then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => loginPage()),
          );
        });
      },
      child: actionButton(Icons.logout_outlined, 'LogOut'),
    );
  }

  Widget deleteAccountButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await clearUserPreferences();
        await authMethods().deleteAccount().then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => onBoarding()),
          );
        });
      },
      child: actionButton(Icons.delete_outline, 'Delete Account'),
    );
  }

  Widget adminPanelButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => adminLoginPage()),
        );
      },
      child: actionButton(Icons.admin_panel_settings_outlined, 'Admin Panel'),
    );
  }

  Widget actionButton(IconData icon, String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(icon, color: Colors.black, size: 35),
              SizedBox(width: 10),
              Text(label, style: appWidget.semiBoldTextFieldStyle()),
              Spacer(),
              Icon(Icons.arrow_forward_ios_outlined, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
