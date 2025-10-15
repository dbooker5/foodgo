import 'package:flutter/material.dart';
import 'package:foodgo/service/widget_support.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Profile", style: AppWidget.boldTextFieldStyle()),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/boy.jpg"),
            ),
            SizedBox(height: 20),
            Text("Booker", style: AppWidget.boldTextFieldStyle()),
            SizedBox(height: 10),
            Text("booker@example.com", style: AppWidget.SimpleTextFieldStyle()),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings", style: AppWidget.SimpleTextFieldStyle()),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout", style: AppWidget.SimpleTextFieldStyle()),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
