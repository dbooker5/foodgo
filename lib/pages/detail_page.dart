import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodgo/service/shared_pref.dart';
import 'package:foodgo/service/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/database.dart';

class DetailPage extends StatefulWidget {
  final String image, name, price;

  const DetailPage({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? paymentIntent;
  String? name, id, email;
  int quantity = 1, totalprice = 0;

  final String secretKey = dotenv.env['STRIPE_SECRET_KEY']!;
  final String checkoutLink =
      "https://buy.stripe.com/test_bJebJ22zs6261uycI74ow00";

  Future<void> getthesharedpref() async {
    name = await SharedPreferencesHelper().getUserName();
    id = await SharedPreferencesHelper().getUserId();
    email = await SharedPreferencesHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getthesharedpref();
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
    totalprice = int.parse(widget.price);
  }

  // ==========================================================
  //   OPTION: WEB / WINDOWS → STRIPE CHECKOUT URL
  // ==========================================================
  Future<void> openStripeCheckoutUrl() async {
    final uri = Uri.parse(checkoutLink);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("https://buy.stripe.com/test_bJebJ22zs6261uycI74ow00");
    }
  }

  // ==========================================================
  //   OPTION: ANDROID / iOS → STRIPE PAYMENT SHEET
  // ==========================================================
  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'FoodGo',
        ),
      );

      await displayPaymentSheet();
    } catch (e, s) {
      debugPrint('Stripe exception: $e | $s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        String orderId = randomAlphaNumeric(10);

        Map<String, dynamic> userOrderMap = {
          "Name": name,
          "Id": id,
          "Quantity": quantity.toString(),
          "Price": totalprice.toString(),
          "Email": email,
          "FoodName": widget.name,
          "FoodImage": widget.image,
          "OrderId": orderId,
          "Status": "Pending",
        };

        await DatabaseMethods().addUserOrderDetails(userOrderMap, id!, orderId);
        await DatabaseMethods().addAdminOrderDetails(userOrderMap, orderId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Order placed successfully!",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Payment Successful!"),
                ],
              ),
            ),
          );
        }

        paymentIntent = null;
      });
    } catch (e) {
      debugPrint("Payment error: $e");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
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

      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('Error creating payment intent: ${err.toString()}');
      rethrow;
    }
  }

  String calculateAmount(String amount) {
    return (int.parse(amount) * 100).toString();
  }

  // ==========================================================
  //   BUILD UI
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Image
              Center(
                child: Image.asset(
                  widget.image,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // Name, Price
              Text(widget.name, style: AppWidget.HeadLineTextFieldStyle()),
              Text("\$${widget.price}", style: AppWidget.priceTextFieldStyle()),

              const SizedBox(height: 30),

              // Description
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "Cheese pizza features a crispy crust topped with tangy tomato sauce and melted mozzarella cheese.",
                  style: AppWidget.SimpleTextFieldStyle(),
                ),
              ),
              const SizedBox(height: 30),

              // Quantity Controls
              Text("Quantity", style: AppWidget.SimpleTextFieldStyle()),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity++;
                        totalprice = int.parse(widget.price) * quantity;
                      });
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      quantity.toString(),
                      key: ValueKey<int>(quantity),
                      style: AppWidget.HeadLineTextFieldStyle(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                          totalprice = int.parse(widget.price) * quantity;
                        });
                      }
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Total Price + Order Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 60,
                      width: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "\$${totalprice.toString()}",
                          style: AppWidget.boldwhiteTextFieldStyle(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),

                  // ORDER BUTTON (Platform Adaptive)
                  GestureDetector(
                    onTap: () async {
                      if (kIsWeb ||
                          defaultTargetPlatform == TargetPlatform.windows) {
                        openStripeCheckoutUrl(); // → Web/Windows
                      } else {
                        await makePayment(
                          totalprice.toString(),
                        ); // → Android/iOS
                      }
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "ORDER NOW",
                            style: AppWidget.whiteTextFieldStyle(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
