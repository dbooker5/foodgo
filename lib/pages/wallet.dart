import 'package:flutter/material.dart';
import 'package:foodgo/service/widget_support.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Wallet", style: AppWidget.boldTextFieldStyle()),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text("Balance: \$ 0.00", style: AppWidget.SimpleTextFieldStyle()),
          ],
        ),
      ),
    );
  }
}
