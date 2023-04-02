import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                var EmailValidator;
                if (EmailValidator.validate(email)) {
                  // Navigate to the ResetPasswordScreen and pass the email as an argument
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(email: email),
                    ),
                  );
                } else {
                  // Show an error message if the email is not valid
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Invalid email'),
                  ));
                }
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  final String email;

  ResetPasswordScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Enter a new password for $email'),
            // Add text fields and a button for resetting the password
          ],
        ),
      ),
    );
  }
}
