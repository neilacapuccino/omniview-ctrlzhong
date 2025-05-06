import 'package:flutter/material.dart';

// Abstract parent class for authentication pages
abstract class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  // Child classes 
  Widget buildForm(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Return',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: buildForm(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Title TExt
class RegisterPage extends AuthPage {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget buildForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C4AB6),
          ),
        ),
        SizedBox(height: 12),
        RegisterFormFields(), // Use the form fields widget
      ],
    );
  }
}

// Email and Password Box
class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Create Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Continue',
            style: TextStyle(
              color: Color(0xFF6C4AB6),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
