import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoneauth/ShoppingApp/services/database.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';
import 'package:random_string/random_string.dart';

class Adproductpagee extends StatefulWidget {
  const Adproductpagee({super.key});

  @override
  State<Adproductpagee> createState() => _AdproductpageeState();
}

class _AdproductpageeState extends State<Adproductpagee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
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
  }

  uploadItem() async {
    if (selectedImage != null && nameController.text.isNotEmpty) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('blogImage').child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadURL = await (await task).ref.getDownloadURL();

      String firstLetter = nameController.text.substring(0, 1).toUpperCase();
      Map<String, dynamic> addProduct = {
        "Name": nameController.text,
        "Image": downloadURL,
        "Price": priceController.text,
        "searchKey": firstLetter,
        "updatedName": nameController.text.toUpperCase(),
        "Detail": detailController.text
      };

      await databaseMethods()
          .addProduct(addProduct, Valuee!)
          .then((value) async {
        await databaseMethods().addAllProducts(addProduct);
        setState(() {
          selectedImage = null;
          nameController.text = '';
          detailController.text = '';
          priceController.text = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product added successfully!'),
        ));
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('An error occurred: $e'),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Please fill in all the fields and select an image.'),
      ));
    }
  }

  String? Valuee;
  final List<String> categoryItem = [
    'Headphone',
    'Laptop',
    'Watch',
    'TV',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload the Product Image',
              style: appWidget.lightTextFieldStyle(),
            ),
            SizedBox(height: 10),
            selectedImage == null
                ? GestureDetector(
                    onTap: getImage,
                    child: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F5F9),
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: getImage,
                    child: Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            Text('Product Name', style: appWidget.lightTextFieldStyle()),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFF4F5F9),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Product Name',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Product Price', style: appWidget.lightTextFieldStyle()),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFF4F5F9),
              ),
              child: TextField(
                controller: priceController,
                decoration: InputDecoration(
                  hintText: 'Enter Product Price',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Product Detail', style: appWidget.lightTextFieldStyle()),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFF4F5F9),
              ),
              child: TextField(
                maxLines: 6,
                controller: detailController,
                decoration: InputDecoration(
                  hintText: 'Enter Product Detail',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Product Category', style: appWidget.lightTextFieldStyle()),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFF4F5F9),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: categoryItem
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: appWidget.lightTextFieldStyle(),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      Valuee = value;
                    });
                  },
                  dropdownColor: Color(0xFFF4F5F9),
                  hint: Text('Select Category'),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  value: Valuee,
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: uploadItem,
                child: Text(
                  'Add Product',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
