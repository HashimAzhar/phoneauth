import 'package:cloud_firestore/cloud_firestore.dart';

class databaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String Id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(Id)
        .set(userInfoMap);
  }

  Future HashimAddUserDetails(
      Map<String, dynamic> userInforMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Userss')
        .doc(id) //
        .set(userInforMap);
  }

  Future addAllProducts(
    Map<String, dynamic> userInfoMap,
  ) async {
    return await FirebaseFirestore.instance
        .collection('Productss')
        .add(userInfoMap);
  }

  Future addProduct(
      Map<String, dynamic> userInfoMap, String categoryName) async {
    return await FirebaseFirestore.instance
        .collection(categoryName)
        .add(userInfoMap);
  }

  updateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .update({"Status": "Delivered"});
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return await FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future<Stream<QuerySnapshot>> allOrders() async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .where("Status", isEqualTo: "On the way")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    print("Fetching orders for email: $email"); // Debugging line
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('Email', isEqualTo: email)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> HshmHomePageDetails(String email) async {
    print("Fetching orders for email: $email"); // Debugging line
    return FirebaseFirestore.instance
        .collection(
            'Users') ////////////////////////////////////////////////////////////////
        .where('Email', isEqualTo: email)
        .snapshots();
  }

  Future orderDetails(Map<String, dynamic> userInforMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Orders')
        .doc(id) //
        .set(userInforMap);
  }

  Future<void> deleteOrder(String docId) async {
    try {
      await FirebaseFirestore.instance.collection("Orders").doc(docId).delete();
    } catch (e) {
      print("Error deleting order: $e");
      throw e;
    }
  }

  Future<QuerySnapshot> search(String updatedName) async {
    if (updatedName.isEmpty) {
      return Future.error("Search term cannot be empty.");
    }

    String searchKey = updatedName.substring(0, 1).toUpperCase();

    return await FirebaseFirestore.instance
        .collection("Productss")
        .where("searchKey", isEqualTo: searchKey)
        .get();
  }
}
