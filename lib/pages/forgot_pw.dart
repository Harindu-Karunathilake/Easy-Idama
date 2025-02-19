import 'package:flutter/material.dart';
import 'signin.dart';
import 'otp.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.2),
                  _buildHeaderText(context),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  _buildDescriptionText(context),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  _buildEmailForm(),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  _buildContinueButton(),
                  SizedBox(height: constraints.maxHeight * 0.3),
                  _buildSignInText(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    return Text(
      "Forgot Password",
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    return Text(
      "Don't worry! It happens. Please enter the email address linked with your account.",
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildEmailForm() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          hintText: 'Email',
          filled: true,
          fillColor: Color(0xFFF5FCF9),
          contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
           Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OtpScreen(),
                              ),
           );

          
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
          "Continue",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInText(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
          );
        },
        child: Text.rich(
          const TextSpan(
            text: "Remember Password? ",
            children: [
              TextSpan(
                text: "Sign In",
                style: TextStyle(color: Color(0xFFF14336)),
              ),
            ],
          ),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.64),
              ),
        ),
      ),
    );
  }
}
