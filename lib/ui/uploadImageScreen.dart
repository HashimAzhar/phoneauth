import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoneauth/fireBaseServices/widgets/roundButton.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class uploadImageScreen extends StatefulWidget {
  const uploadImageScreen({super.key});

  @override
  State<uploadImageScreen> createState() => _uploadImageScreenState();
}

class _uploadImageScreenState extends State<uploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image Picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Icon(Icons.image),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            roundButton(
              title: 'Upload',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/Hashim Gallery/' +
                        DateTime.now().millisecondsSinceEpoch.toString());
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute);
                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();
                  final iD = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef.child(iD).set(
                      {'id': 1212, 'title': newUrl.toString()}).then((Value) {
                    setState(() {
                      loading = false;
                    });
                    debugPrint('Data Saved in Firebase');
                    Utils().toastMessage('Uploaded');
                  }).onError((error, StackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString() + 'Detected'); //
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
