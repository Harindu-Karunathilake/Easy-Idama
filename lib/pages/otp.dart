import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(title: Text("Password Reset")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Password reset email sent to your email address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // You can navigate back or to another screen
                  Navigator.pop(context);
                },
                child: Text("Go Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




