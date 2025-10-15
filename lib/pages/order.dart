import 'package:flutter/material.dart';
import 'package:foodgo/service/widget_support.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Your Orders", style: AppWidget.boldTextFieldStyle()),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          "No active orders yet.",
          style: AppWidget.SimpleTextFieldStyle(),
        ),
      ),
    );
  }
}
