import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodgo/pages/bottomnav.dart';
import 'package:foodgo/pages/signup.dart';
import 'package:foodgo/service/shared_pref.dart';

import '../service/widget_support.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // === Controllers ===
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // === Login Function ===
  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Please fill in all fields",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      // Firebase login
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Save email to shared preferences
      await SharedPreferencesHelper().saveUserEmail(email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Login successful!", style: TextStyle(fontSize: 18)),
        ),
      );

      // Navigate to BottomNav
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(errorMessage, style: const TextStyle(fontSize: 18)),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // === Build UI ===
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // === Top Banner ===
            Container(
              height: MediaQuery.of(context).size.height / 2,
              padding: const EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
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

            // === Login Form ===
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height / 1.65,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Log In",
                            style: AppWidget.HeadLineTextFieldStyle(),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // === Email ===
                        Text("Email", style: AppWidget.SignUpTextFieldStyle()),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: emailController,
                          hint: "Enter Email",
                          icon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 20),

                        // === Password ===
                        Text(
                          "Password",
                          style: AppWidget.priceTextFieldStyle(),
                        ),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: passwordController,
                          hint: "Enter Password",
                          icon: Icons.lock_outline,
                          obscureText: true,
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forgot Password?",
                              style: AppWidget.SimpleTextFieldStyle(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // === Login Button ===
                        Center(
                          child: GestureDetector(
                            onTap: loginUser,
                            child: Container(
                              height: 60,
                              width: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xffef2b39),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        "Log In",
                                        style:
                                            AppWidget.boldwhiteTextFieldStyle(),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // === SignUp Redirect ===
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: AppWidget.SimpleTextFieldStyle(),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: AppWidget.boldTextFieldStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === TextField Builder ===
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
