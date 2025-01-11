import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/admin/adProductPagee.dart';
import 'package:phoneauth/ShoppingApp/admin/allOrders.dart';
import 'package:phoneauth/ShoppingApp/pages/bottomNav.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';

class adminHomePage extends StatefulWidget {
  const adminHomePage({super.key});

  @override
  State<adminHomePage> createState() => _adminHomePageState();
}

class _adminHomePageState extends State<adminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        appBar: AppBar(
          backgroundColor: const Color(0xfff2f2f2),
          title: Text(
            'Home Admin',
            style: appWidget.boldTextFieldStyle(),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 3,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Adproductpagee()));
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Add Product',
                          style: appWidget.semiBoldTextFieldStyle(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 3,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => allOrders()));
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.black,
                          size: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'All Orders',
                          style: appWidget.semiBoldTextFieldStyle(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 3,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => bottomNav()));
                  },
                  child: Container(
                    padding: EdgeInsetsDirectional.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Colors.black,
                          size: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'User Panel',
                          style: appWidget.semiBoldTextFieldStyle(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
