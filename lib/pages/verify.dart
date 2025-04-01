import 'package:flutter/material.dart';
import 'package:mad/pages/checkout.dart';

class VerifyScreen extends StatelessWidget {
  final String listingId; // Receive the listing ID

  const VerifyScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/onboard2.jpg', // Ensure the image exists in assets
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: "Get your listing verified!",
                titleStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                description: "Our team will verify your listing and get it live on the platform.",
                btnText: "Proceed",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(listingId: listingId), // Pass listingId
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String description;
  final String btnText;
  final VoidCallback press;

  const ErrorInfo({
    super.key,
    required this.title,
    this.titleStyle,
    required this.description,
    required this.btnText,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: titleStyle ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: press,
          child: Text(
            btnText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
