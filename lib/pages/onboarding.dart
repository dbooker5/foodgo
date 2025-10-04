import 'package:flutter/material.dart';

import '../service/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Column(children: [
        Image.asset(
            'images/onboard.png'
        ),
        Text("The Fastest\n Food Delivery", style: AppWidget.HeadLineTextFieldStyle(),)
      ],)
      )
    );
  }
}
