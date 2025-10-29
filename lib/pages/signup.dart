import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodgo/pages/bottomnav.dart';
import 'package:foodgo/service/database.dart';
import 'package:foodgo/service/shared_pref.dart';
import 'package:random_string/random_string.dart';

import '../service/widget_support.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // For showing loading indicator

  // Register user method
  Future<void> registration() async {
    String email = mailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String id = randomAlphaNumeric(10);

      Map<String, dynamic> userInfoMap = {
        "Name": name,
        "Email": email,
        "Id": id,
      };

      // Save to SharedPreferences & Firestore in parallel
      await Future.wait([
        SharedPreferencesHelper().saveUserEmail(email),
        SharedPreferencesHelper().saveUserName(name),
        DatabaseMethods().addUserDetails(userInfoMap, id),
      ]);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Account created successfully!",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );

      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'weak-password') {
        errorMessage = "Password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(errorMessage, style: const TextStyle(fontSize: 18)),
        ),
      );
    }
  }

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

            // === Sign Up Form ===
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
                            "Sign Up",
                            style: AppWidget.HeadLineTextFieldStyle(),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // === Name Field ===
                        Text("Name", style: AppWidget.SignUpTextFieldStyle()),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: nameController,
                          hint: "Enter Name",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),

                        // === Email Field ===
                        Text("Email", style: AppWidget.SignUpTextFieldStyle()),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: mailController,
                          hint: "Enter Email",
                          icon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 20),

                        // === Password Field ===
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
                        const SizedBox(height: 20),

                        // === Sign Up Button ===
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (nameController.text.isNotEmpty &&
                                  mailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                setState(() => isLoading = true);
                                await registration();
                                setState(() => isLoading = false);
                              }
                            },
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
                                        "Sign Up",
                                        style:
                                            AppWidget.boldwhiteTextFieldStyle(),
                                      ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // === Login Redirect ===
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: AppWidget.SimpleTextFieldStyle(),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LogIn(),
                                  ),
                                );
                              },
                              child: Text(
                                "Log In",
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

  // === Custom TextField Builder ===
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

  // === Dispose controllers to free memory ===
  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
