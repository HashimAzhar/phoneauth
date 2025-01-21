import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/services/database.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class orderPage extends StatefulWidget {
  const orderPage({super.key});

  @override
  State<orderPage> createState() => _orderPageState();
}

class _orderPageState extends State<orderPage> {
  String? email;
  Stream? orderStream;

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  Future<void> deleteOrder(String docId) async {
    await databaseMethods().deleteOrder(docId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order deleted successfully!")),
    );
  }

  Future<void> getOnTheLoad() async {
    email = await sharedPreferenceHelper().getUserEmail();
    if (email != null) {
      orderStream = await databaseMethods().getOrders(email!);
    }
    setState(() {});
  }

  TextStyle universalTitleStyle(BuildContext context) => TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.bold,
      );

  TextStyle universalPriceStyle(BuildContext context) => TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.045,
        color: const Color(0xFFfd6f3e),
        fontWeight: FontWeight.w600,
      );

  TextStyle universalStatusStyle(BuildContext context) => TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.04,
        color: const Color(0xFFfd6f3e),
        fontWeight: FontWeight.w500,
      );

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
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.network(
                              ds['Image'],
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ds['productName'],
                                    style: universalTitleStyle(context),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${ds['Price']}',
                                    style: universalPriceStyle(context),
                                  ),
                                  Text(
                                    'Status: ${ds['Status']}',
                                    style: universalStatusStyle(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 1,
                        child: PopupMenuButton(
                          color: Colors.white,
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(ds['Id']);
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                              ),
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
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 143, 141, 141),
        title: Text(
          'Current Orders',
          style: universalTitleStyle(context),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Column(
          children: [Expanded(child: allOrders())],
        ),
      ),
    );
  }

  Future<void> showMyDialog(String id) async {
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
                    databaseMethods().deleteOrder(id).then((value) {
                      Utils().toastMessage('Order Deleted');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Delete')),
            ],
          );
        });
  }
}
