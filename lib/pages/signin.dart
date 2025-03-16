import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'forgot_pw.dart';
import 'home.dart'; // Import the HomeScreen
import 'admin/admin_dashboard.dart'; // Import the AdminDashboardScreen
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false; // State for "Remember Me" checkbox
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials when screen opens
  }

  Future<void> _signIn() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save credentials if "Remember Me" is checked
      _saveCredentials();

      // Fetch user role from Firestore
      String userId = userCredential.user!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        String status = userDoc['status'] ?? 'active'; // Default to active if status is missing
        String role = userDoc['role'] ?? 'user'; // Default to 'user' if role is missing

        if (status.toLowerCase() == 'inactive') {
          // Sign out immediately if user is inactive
          await _auth.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your account is inactive. Contact support for assistance.")),
          );
          return;
        }

        if (role == 'admin') {
          // Navigate to Admin Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } else {
          // Navigate to Regular User Home Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        _showErrorDialog('User data not found.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog('Wrong password provided.');
      } else {
        _showErrorDialog('An error occurred. Please try again.');
      }
    }
  }

  // Load saved credentials
  void _loadSavedCredentials() async {
    String? savedEmail = await storage.read(key: "email");
    String? savedPassword = await storage.read(key: "password");

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  // Save credentials if "Remember Me" is checked
  void _saveCredentials() async {
    if (_rememberMe) {
      await storage.write(key: "email", value: _emailController.text);
      await storage.write(key: "password", value: _passwordController.text);
    } else {
      await storage.delete(key: "email");
      await storage.delete(key: "password");
    }
  }

  // Method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hello Again!",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: const Color(0xFFF5FCF9),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: const Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 16.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        // Remember Me and Forgot Password Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value!;
                                    });
                                  },
                                  activeColor: const Color(0xFF1471D3),
                                ),
                                const Text("Remember Me"),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withOpacity(0.64),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signIn();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFF1471D3),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.2),
                        TextButton(
                          onPressed: () {
                            // Navigate to the SignUpScreen when Sign Up is pressed
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Don’t have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Color(0xFFF14336)),
                                ),
                              ],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.64),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
