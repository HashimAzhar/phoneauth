import 'package:flutter/material.dart';

class ShowImagePage extends StatelessWidget {
  final String imageUrl;

  const ShowImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Profile Image",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          height:
              MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain, // Ensure the image scales well
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
