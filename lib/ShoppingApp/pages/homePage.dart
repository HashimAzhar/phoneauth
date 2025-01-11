import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/ShoppingApp/pages/productDetailPage.dart';
import 'package:phoneauth/ShoppingApp/pages/productsCategory.dart';
import 'package:phoneauth/ShoppingApp/services/database.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
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

  String? name, image;

  Future<void> getTheSharedPreference() async {
    name = await sharedPreferenceHelper().getUserName();
    image = await sharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  Future<void> onTheLoad() async {
    await getTheSharedPreference();
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hey, $name',
                                style: appWidget.boldTextFieldStyle()),
                            Text('Good Morning ',
                                style: appWidget.lightTextFieldStyle()),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            image!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                            hintText: 'Search Products',
                            border: InputBorder.none,
                            hintStyle: appWidget.lightTextFieldStyle(),
                            prefixIcon: search
                                ? GestureDetector(
                                    onTap: () {
                                      search = false;
                                      tempSearchStore = [];
                                      queryResultSet = [];
                                      searchController.text = '';
                                      setState(() {});
                                    },
                                    child: Icon(Icons.close),
                                  )
                                : Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    search
                        ? ListView(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    style: appWidget.semiBoldTextFieldStyle(),
                                  ),
                                  const Text(
                                    'see all',
                                    style: TextStyle(
                                        color: Color(0xFFfd6f3e),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    height: 130,
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.only(right: 20),
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
                                  Expanded(
                                    child: Container(
                                      height: 130,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categories.length,
                                        itemBuilder: (context, index) {
                                          return categoryTile(
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
                                    style: appWidget.semiBoldTextFieldStyle(),
                                  ),
                                  const Text(
                                    'see all',
                                    style: TextStyle(
                                        color: Color(0xFFfd6f3e),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                height: 240,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    productCard('images/headphone2.png',
                                        'Headphone', 100),
                                    productCard('images/watch2.png',
                                        'Apple Watch', 300),
                                    productCard(
                                        'images/laptop2.png', 'Laptop', 300),
                                  ],
                                ),
                              ),
                            ],
                          )
                  ],
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
        padding: EdgeInsets.only(left: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data['Image'],
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              data['Name'],
              style: appWidget.semiBoldTextFieldStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(String imagePath, String name, int price) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.asset(imagePath, height: 150, width: 150, fit: BoxFit.cover),
          Text(name, style: appWidget.semiBoldTextFieldStyle()),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('\$$price',
                  style: const TextStyle(
                      color: Color(0xFFfd6f3e),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 40),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xFFfd6f3e),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class categoryTile extends StatelessWidget {
  final String image, name;
  const categoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => productsCategory(category: name)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(image, height: 50, width: 50, fit: BoxFit.cover),
            const Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
