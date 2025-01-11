import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phoneauth/ShoppingApp/services/database.dart';
import 'package:phoneauth/ShoppingApp/services/sharedPreference.dart';
import 'package:phoneauth/ShoppingApp/widgets/supportWidget.dart';

class ProductDetailPage extends StatefulWidget {
  final String name, image, detail, price;

  ProductDetailPage({
    required this.name,
    required this.image,
    required this.detail,
    required this.price,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String publishableKey =
      'pk_test_51QUYRtFQkZIkeo3vCRpQWmp0oM0lbhYUowsChSDFlSWJmBbr4ftULUBGV9aUwfe2q9mWy7jqjbUCu0IK5SAVPTof00ujn6YH1G';
  String secretKey =
      'sk_test_51QUYRtFQkZIkeo3vq1tKbx8M4pZ5S9vEFLWyNoT8i67IUZapIvzDe5qf0xtl3B3yhQ06CCZzChzfA1TCSd1obsJZ001ABQ9E58';

  Map<String, dynamic>? paymentIntent;
  String? email;
  String? userImage;
  String? userName;
  String id = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = publishableKey;
    _getEmail();
  }

  Future<void> _getEmail() async {
    email = await sharedPreferenceHelper().getUserEmail();
    userImage = await sharedPreferenceHelper().getUserImage();
    userName = await sharedPreferenceHelper().getUserName();
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to fetch email. Please log in.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> buyFunction() async {
      if (email != null) {
        Map<String, dynamic> addProductDetails = {
          "productName": widget.name,
          "Image": widget.image,
          "Price": widget.price,
          "Detail": widget.detail,
          "Email": email!,
          "userImage": userImage!,
          "userName": userName!,
          "Id": id,
          "Status": "On the way",
        };
        await databaseMethods().orderDetails(addProductDetails, id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email not found. Cannot place order.")),
        );
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFfef5f1),
      body: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.network(
                    widget.image,
                    height: 400,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product Name - wrap with Expanded to allow wrapping text
                        Expanded(
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap:
                                true, // Ensures text wraps to the next line
                            maxLines: null, // Allows unlimited lines
                          ),
                        ),
                        // Product Price
                        Text(
                          '\$${widget.price}',
                          style: TextStyle(
                            color: Color(0xFFfd6f3e),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      widget.detail,
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        bool paymentSuccessful =
                            await makePayment(widget.price);
                        if (paymentSuccessful) {
                          await buyFunction();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 38, 33, 32),
                        ),
                        child: Center(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Your Shop',
        ),
      );
      return await displayPaymentSheet();
    } catch (e) {
      print('Error during makePayment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed. Please try again.")),
      );
      return false; // Payment failed
    }
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment successful!")),
      );
      paymentIntent = null;
      return true; // Payment succeeded
    } on StripeException catch (e) {
      print('Stripe Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment cancelled.")),
      );
      return false; // Payment cancelled
    } catch (e) {
      print('General Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed. Please try again.")),
      );
      return false; // Payment failed
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (err) {
      rethrow;
    }
  }

  String calculateAmount(String amount) {
    final int calculatedAmount = (double.parse(amount) * 100).toInt();
    return calculatedAmount.toString();
  }
}
