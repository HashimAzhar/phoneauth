import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/pages/loginPage.dart';
import 'package:phoneauth/ShoppingApp/pages/productDetailPage.dart';
import 'package:phoneauth/ShoppingApp/pages/productsCategory.dart';
import 'package:phoneauth/ShoppingApp/pages/showImage.dart';
import 'package:phoneauth/ShoppingApp/pages/testProdcutPage.dart';
import 'package:phoneauth/ShoppingApp/services/database.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final auth = FirebaseAuth.instance;
  final fireStore =
      FirebaseFirestore.instance.collection('Productss').snapshots();
  bool search = false;
  List categories = [
    'images/headphone_icon.png',
    'images/laptop.png',
    'images/watch.png',
    'images/TV.png',
  ];
  List categoryName = [
    'Headphone',
    'Laptop',
    'Watch',
    'TV',
  ];
  TextEditingController searchController = TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];
  String? name, image, fetchedEmail;

  @override
  void initState() {
    super.initState();
    _onLoad();
  }

  Future<void> _onLoad() async {
    name = await sharedPreferenceHelper().getUserName();
    image = await sharedPreferenceHelper().getUserImage();
    fetchedEmail = await sharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  void initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        search = false;
      });
      return;
    }

    setState(() {
      search = true;
    });

    var capitalizedValue = value[0].toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      databaseMethods().search(value).then((QuerySnapshot docs) {
        setState(() {
          queryResultSet = docs.docs.map((doc) => doc.data()).toList();
        });
      });
    } else {
      tempSearchStore = [];
      for (var element in queryResultSet) {
        if (element['updatedName'] != null &&
            element['updatedName'].toString().startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
  }

  Widget buildProductGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Some Error has occurred');
        }

        return GridView.builder(
          itemCount: snapshot.data!.docs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height * 0.75),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final name = snapshot.data!.docs[index]['Name'].toString();
            final price = snapshot.data!.docs[index]['Price'].toString();
            final imageUrl = snapshot.data!.docs[index]['Image'].toString();
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${price}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFfd6f3e),
                        ),
                      ),
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFfd6f3e),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: name == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hey, $name',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Good Morning',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowImagePage(imageUrl: image!),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  image!,
                                  height: screenWidth * 0.15,
                                  width: screenWidth * 0.15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            initiateSearch(value.toUpperCase());
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Products',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey),
                            prefixIcon: search
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        search = false;
                                        tempSearchStore = [];
                                        queryResultSet = [];
                                        searchController.text = '';
                                      });
                                    },
                                    child: const Icon(Icons.close),
                                  )
                                : const Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      search
                          ? ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              primary: false,
                              shrinkWrap: true,
                              children: tempSearchStore.map((element) {
                                return buildResultCard(element);
                              }).toList(),
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Categories',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Testprodcutpage()),
                                        );
                                      },
                                      child: Container(
                                        height: screenHeight * 0.15,
                                        padding: const EdgeInsets.all(20),
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFD6F3E),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                          child: Text(
                                            'All',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: screenHeight * 0.15,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: categories.length,
                                          itemBuilder: (context, index) {
                                            return CategoryTile(
                                              image: categories[index],
                                              name: categoryName[index],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'All Products',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: SizedBox(
                                    height: screenHeight * 0.5,
                                    child: buildProductGrid(),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                      name: data["Name"],
                      image: data["Image"],
                      detail: data["Detail"],
                      price: data["Price"])));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: MediaQuery.of(context).size.height * 0.02),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  data['Image'],
                  height: MediaQuery.of(context).size.height *
                      0.1, // 10% of screen height
                  width: MediaQuery.of(context).size.width *
                      0.15, // 15% of screen width
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data['Name'],
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width *
                        0.04, // 4% of screen width
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class CategoryTile extends StatelessWidget {
  final String image, name;
  const CategoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => productsCategory(category: name)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        margin: EdgeInsets.only(right: screenWidth * 0.05),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(image,
                height: screenHeight * 0.06,
                width: screenWidth * 0.1,
                fit: BoxFit.cover),
            const Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
