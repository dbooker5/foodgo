import 'package:flutter/material.dart';

import '../service/widget_support.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              padding: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffffefbf),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "images/pan.png",
                    height: 180,
                    width: 240,
                    fit: BoxFit.fill,
                  ),
                  Image.asset(
                    "images/logo.png",
                    height: 50,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.5,
                left: 20,
                right: 20,
              ),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Sign Up",
                          style: AppWidget.HeadLineTextFieldStyle(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Name", style: AppWidget.priceTextFieldStyle()),
                      Container(child: TextField()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
