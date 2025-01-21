import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneauth/ShoppingApp/pages/productDetailPage.dart';
import 'package:phoneauth/ui/auth/loginScreen.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class Testprodcutpage extends StatefulWidget {
  const Testprodcutpage({super.key});

  @override
  State<Testprodcutpage> createState() => _TestprodcutpageState();
}

class _TestprodcutpageState extends State<Testprodcutpage> {
  final auth = FirebaseAuth.instance;
  final fireStore =
      FirebaseFirestore.instance.collection('Productss').snapshots();

  Widget buildProductGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot>(
      stream: fireStore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Some Error has occurred');
        }

        return Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            itemCount: snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              childAspectRatio: screenWidth / (screenHeight * 0.6),
              mainAxisSpacing: screenHeight * 0.02,
              crossAxisSpacing: screenWidth * 0.03,
            ),
            itemBuilder: (context, index) {
              final name = snapshot.data!.docs[index]['Name'].toString();
              final price = snapshot.data!.docs[index]['Price'].toString();
              final imageUrl = snapshot.data!.docs[index]['Image'].toString();
              return Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      child: Image.network(
                        imageUrl,
                        height: screenHeight * 0.15,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    // Product Name with Truncated Text
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),

                    // Price and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product Price
                        Text(
                          '\$${price}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfd6f3e),
                          ),
                        ),

                        // Add Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  name: name,
                                  image: imageUrl,
                                  detail: snapshot.data!.docs[index]['Detail'],
                                  price: price,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            decoration: BoxDecoration(
                              color: Color(0xFFfd6f3e),
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: screenWidth * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: const Text('All Products'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            buildProductGrid(context),
          ],
        ),
      ),
    );
  }
}
