import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle HeadLineTextFieldStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle SimpleTextFieldStyle() {
    return TextStyle(color: Colors.black, fontSize: 18);
  }

  static TextStyle whiteTextFieldStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle boldTextFieldStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle priceTextFieldStyle() {
    return TextStyle(
      color: const Color.fromARGB(174, 0, 0, 0),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle boldwhiteTextFieldStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
  }
}
