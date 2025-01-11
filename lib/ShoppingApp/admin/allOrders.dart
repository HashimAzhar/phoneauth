import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/services/database.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class allOrders extends StatefulWidget {
  const allOrders({super.key});

  @override
  State<allOrders> createState() => _allOrdersState();
}

class _allOrdersState extends State<allOrders> {
  Stream? orderStream;
  String? email;
  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  Future<void> getOnTheLoad() async {
    orderStream = await databaseMethods().allOrders();

    setState(() {});
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
          return const Center(
            child: Text(
              "No orders found!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              ds['userImage'],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ' + ds['userName'],
                                  style: appWidget.semiBoldTextFieldStyle(),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Email: ' + ds['Email'],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ds['productName'],
                                  style: appWidget.semiBoldTextFieldStyle(),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '\$${ds['Price']}',
                                  style: const TextStyle(
                                    color: Color(0xFFfd6f3e),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () async {
                                    databaseMethods().updateStatus(ds['Id']);
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFfd6f3e),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                      'Done',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'All Orders',
          style: appWidget.boldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: [Expanded(child: allOrders())],
        ),
      ),
    );
  }

  Future<void> showMyDialog(String Id) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    databaseMethods().deleteOrder(Id).then((value) {
                      Utils().toastMessage('Order Deleted');
                    }).onError((error, StackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Delete')),
            ],
          );
        });
  }
}
