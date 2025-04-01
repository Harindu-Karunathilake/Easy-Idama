import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mad/pages/home.dart';

class PayPalPaymentScreen extends StatefulWidget {
  final String listingId; // Pass listing ID when navigating to this screen

  const PayPalPaymentScreen({Key? key, required this.listingId}) : super(key: key);

  @override
  State<PayPalPaymentScreen> createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  String _result = '';
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    if (mounted) {
      setState(() {
        _isProcessing = true;
        _result = '';
      });
    }

    try {
      const fixedAmount = '19.99';
      const currency = 'USD';
      const productName = 'Premium Subscription';

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckoutView(
            sandboxMode: true,
            clientId: "ATxPCSgmN2g1lMthbvUY0hi0w4zbqPaeqt_bYHDv0k2P7tkmihiSKhqRtabslhI8E-5rRaQO_S7lVcsx",
            secretKey: "EL7BNl5fTGIOWUFG5gNjSNpjAr5QmdvpHoZqgm1Wb_-Mw02yIL46CKoMBgR657zyoXmSHvMrYr37mNTo",
            transactions: [
              {
                "amount": {
                  "total": fixedAmount,
                  "currency": currency,
                  "details": {
                    "subtotal": fixedAmount,
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "Payment for $productName",
                "item_list": {
                  "items": [
                    {
                      "name": productName,
                      "quantity": 1,
                      "price": fixedAmount,
                      "currency": currency
                    }
                  ]
                }
              }
            ],
            note: "Thank you for your purchase!",

          onSuccess: (Map params) async {
  if (mounted) {
    setState(() {
      _isProcessing = true;
    });
  }

  String userId = FirebaseAuth.instance.currentUser?.uid ?? "unknown_user";

  // Store payment details in Firestore
  await FirebaseFirestore.instance.collection('verifications').add({
    'userId': userId,
    'listingId': widget.listingId,
    'verifyStatus': 'pending',
    'amount': 19.99,
    'paymentId': params['paymentId'],
    'timestamp': FieldValue.serverTimestamp(),
  });

  if (mounted) {
    setState(() {
      _isProcessing = false;
    });
  }

  // ✅ Navigate to Home and pass success message
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(successMessage: "✅ Payment successful!"),
    ),
  );
},




            onError: (error) {
              if (mounted) {
                setState(() {
                  _result = 'Payment failed: $error';
                  _isProcessing = false;
                });
              }
              Navigator.pop(context);
            },

            onCancel: () {
              if (mounted) {
                setState(() {
                  _result = 'Payment cancelled';
                  _isProcessing = false;
                });
              }
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _result = 'Error: $e';
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Service'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Verify your listing',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '\$19.99',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: _isProcessing ? null : _processPayment,
                          child: _isProcessing
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : const Text(
                                  'Pay Now',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_result.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _result.contains('successful')
                        ? Colors.green[50]
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _result,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _result.contains('successful')
                          ? Colors.green[800]
                          : Colors.red[800],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
