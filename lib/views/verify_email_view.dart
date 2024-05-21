import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool _isLoading = false;
  String? _message;

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.sendEmailVerification();
        _message = 'Verification email sent. Please check your inbox.';
      } catch (e) {
        _message = 'Failed to send verification email: $e';
      }
    } else {
      _message = 'No user is currently signed in.';
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.black,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please verify your email address:'),
            const SizedBox(height: 16.0),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              TextButton(
                onPressed: _sendVerificationEmail,
                child: const Text("Send Email Verification"),
              ),
            if (_message != null) ...[
              const SizedBox(height: 16.0),
              Text(
                _message!,
                style: TextStyle(
                  color:
                      _message!.contains('Failed') ? Colors.red : Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
