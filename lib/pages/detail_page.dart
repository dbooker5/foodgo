import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodgo/service/widget_support.dart';
import 'package:http/http.dart' as http;

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
  int quantity = 1;
  late int totalprice;
  Map<String, dynamic>? paymentIntent;

  final String secretKey = dotenv.env['STRIPE_SECRET_KEY']!;

  @override
  void initState() {
    super.initState();
    totalprice = int.parse(widget.price);
  }

  /// ===== Stripe Payment Logic =====
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
      debugPrint('Exception: $e$s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // success dialog
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
    } on StripeException catch (e) {
      debugPrint('Stripe error: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(content: Text("Payment cancelled")),
        );
      }
    } catch (e) {
      debugPrint('General error: $e');
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
      debugPrint('Error charging user: ${err.toString()}');
      rethrow;
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100).toString();
    return calculatedAmount;
  }

  /// ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Back Button ===
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

              // === Image ===
              Center(
                child: Image.asset(
                  widget.image,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // === Name and Price ===
              Text(widget.name, style: AppWidget.HeadLineTextFieldStyle()),
              Text("\$${widget.price}", style: AppWidget.priceTextFieldStyle()),

              const SizedBox(height: 30),

              // === Description ===
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "Cheese pizza features a crispy crust topped with tangy tomato sauce and melted mozzarella cheese. Simple, comforting, and delicious — it’s the classic favorite loved by all ages.",
                  style: AppWidget.SimpleTextFieldStyle(),
                ),
              ),
              const SizedBox(height: 30),

              // === Quantity Controls ===
              Text("Quantity", style: AppWidget.SimpleTextFieldStyle()),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Add Button
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

                  // Quantity Display
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Text(
                      quantity.toString(),
                      key: ValueKey<int>(quantity),
                      style: AppWidget.HeadLineTextFieldStyle(),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Remove Button
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

              // === Total & Order Button ===
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Total Price
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
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            "\$${totalprice.toString()}",
                            key: ValueKey<int>(totalprice),
                            style: AppWidget.boldwhiteTextFieldStyle(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),

                  // Order Button
                  GestureDetector(
                    onTap: () async {
                      await makePayment(totalprice.toString());
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
